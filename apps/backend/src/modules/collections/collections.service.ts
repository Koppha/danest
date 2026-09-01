import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

export interface ExpectedCashBreakdown {
  periodStart: Date;
  periodEnd: Date;
  cashSales: number;
  cashDeposits: number;
  cashRefunds: number;
  cashExpenses: number;
  expected: number;
  nonCash: { card: number; mobileMoney: number; bankTransfer: number; prepaidUsage: number; loyaltyRedemptions: number };
}

@Injectable()
export class CollectionsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  private async lastCollectionCutoff(branchId: string): Promise<Date> {
    const last = await this.prisma.cashCollection.findFirst({
      where: { branchId },
      orderBy: { periodEndAt: 'desc' },
    });
    return last?.periodEndAt ?? new Date(0);
  }

  /**
   * Expected cash = cash sales + cash prepaid deposits − cash refunds −
   * cash-paid expenses, all restricted to [periodStart, periodEnd) for this
   * branch. Card/mobile-money/bank-transfer/prepaid-usage/loyalty are
   * reported for verification only and never subtracted from physical cash.
   */
  async computeExpected(branchId: string, periodEnd: Date = new Date()): Promise<ExpectedCashBreakdown> {
    const periodStart = await this.lastCollectionCutoff(branchId);
    if (periodEnd <= periodStart) throw new BadRequestException('periodEnd must be after the last collection cut-off');

    const cashPayments = await this.prisma.paymentComponent.findMany({
      where: {
        paymentMethod: { code: 'CASH' },
        payment: {
          voided: false,
          completedAt: { gte: periodStart, lt: periodEnd },
          washOrder: { branchId },
        },
      },
      select: { amount: true },
    });
    const cashSales = cashPayments.reduce((sum, p) => sum + Number(p.amount), 0);

    const cashRefundComponents = await this.prisma.paymentComponent.findMany({
      where: {
        paymentMethod: { code: 'CASH' },
        payment: { voided: true, voidedAt: { gte: periodStart, lt: periodEnd }, washOrder: { branchId } },
      },
      select: { amount: true },
    });
    const cashRefunds = cashRefundComponents.reduce((sum, p) => sum + Number(p.amount), 0);

    const cashDepositRows = await this.prisma.prepaidWalletLedgerEntry.findMany({
      where: {
        entryType: 'DEPOSIT',
        method: 'CASH',
        createdAt: { gte: periodStart, lt: periodEnd },
        wallet: { customer: { branchId } },
      },
      select: { amount: true },
    });
    const cashDeposits = cashDepositRows.reduce((sum, d) => sum + Number(d.amount), 0);

    // Includes reversal rows (negative amounts), which net corrections out automatically.
    const cashExpenseRows = await this.prisma.expense.findMany({
      where: { branchId, paymentMethod: 'CASH', createdAt: { gte: periodStart, lt: periodEnd } },
      select: { amount: true },
    });
    const cashExpenses = cashExpenseRows.reduce((sum, e) => sum + Number(e.amount), 0);

    const [cardRows, mmRows, bankRows, packageRows, loyaltyRows] = await Promise.all([
      this.sumComponents(branchId, periodStart, periodEnd, 'CARD'),
      this.sumComponents(branchId, periodStart, periodEnd, 'MOBILE_MONEY'),
      this.sumComponents(branchId, periodStart, periodEnd, 'BANK_TRANSFER'),
      this.sumComponents(branchId, periodStart, periodEnd, 'PACKAGE'),
      this.sumComponents(branchId, periodStart, periodEnd, 'LOYALTY_FREE_WASH'),
    ]);

    return {
      periodStart,
      periodEnd,
      cashSales,
      cashDeposits,
      cashRefunds,
      cashExpenses,
      expected: cashSales + cashDeposits - cashRefunds - cashExpenses,
      nonCash: { card: cardRows, mobileMoney: mmRows, bankTransfer: bankRows, prepaidUsage: packageRows, loyaltyRedemptions: loyaltyRows },
    };
  }

  private async sumComponents(branchId: string, start: Date, end: Date, method: string) {
    const rows = await this.prisma.paymentComponent.findMany({
      where: {
        paymentMethod: { code: method as any },
        payment: { voided: false, completedAt: { gte: start, lt: end }, washOrder: { branchId } },
      },
      select: { amount: true },
    });
    return rows.reduce((sum, r) => sum + Number(r.amount), 0);
  }

  /**
   * Idempotent on params.id (client UUID) so an offline-queued retry never
   * duplicates a collection. params.countedAt — when the attendant actually
   * counted the cash, which may be well before this request lands if it was
   * queued offline — is used as the period end instead of server "now", so
   * a late sync doesn't pull in transactions the attendant never saw.
   */
  async confirm(params: {
    id?: string;
    branchId: string;
    countedCash: number;
    varianceReason?: string;
    witness?: string;
    notes?: string;
    countedAt?: string;
    actor: AuthenticatedUser;
  }) {
    if (params.id) {
      const existing = await this.prisma.cashCollection.findUnique({ where: { id: params.id } });
      if (existing) return { collection: existing, breakdown: await this.computeExpected(params.branchId, existing.periodEndAt) };
    }

    const breakdown = await this.computeExpected(params.branchId, params.countedAt ? new Date(params.countedAt) : undefined);
    const variance = params.countedCash - breakdown.expected;
    const result = variance === 0 ? 'MATCHED' : variance < 0 ? 'SHORT' : 'OVER';

    if (result !== 'MATCHED' && !params.varianceReason) {
      throw new BadRequestException('A reason is required when actual cash does not match expected cash');
    }

    const collection = await this.prisma.cashCollection.create({
      data: {
        id: params.id,
        branchId: params.branchId,
        periodStartAt: breakdown.periodStart,
        periodEndAt: breakdown.periodEnd,
        expectedCash: breakdown.expected,
        countedCash: params.countedCash,
        variance,
        result,
        varianceReason: params.varianceReason,
        collectedById: params.actor.userId,
        witness: params.witness,
        notes: params.notes,
      },
    });

    await this.audit.record({
      branchId: params.branchId,
      userId: params.actor.userId,
      deviceId: params.actor.deviceId,
      action: 'CASH_COLLECTION_CONFIRMED',
      entityType: 'CashCollection',
      entityId: collection.id,
      afterSnapshot: { expected: breakdown.expected, counted: params.countedCash, result },
    });

    return { collection, breakdown };
  }

  list(branchId: string) {
    return this.prisma.cashCollection.findMany({ where: { branchId }, orderBy: { createdAt: 'desc' } });
  }
}
