import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';
import type { PaymentMethodCode } from '@prisma/client';

type Tx = Prisma.TransactionClient;

@Injectable()
export class PrepaidService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async getOrCreateWallet(tx: Tx, customerId: string) {
    const existing = await tx.prepaidWallet.findUnique({ where: { customerId } });
    if (existing) return existing;
    return tx.prepaidWallet.create({ data: { customerId, balance: 0 } });
  }

  /** Deposits are a financial event only — never credited to the loyalty ledger. */
  async deposit(params: {
    customerId: string;
    amount: number;
    method: PaymentMethodCode;
    reference?: string;
    clientEntryId: string;
    actor: AuthenticatedUser;
  }) {
    return this.prisma.$transaction(async (tx) => {
      const existingEntry = await tx.prepaidWalletLedgerEntry.findUnique({
        where: { clientEntryId: params.clientEntryId },
      });
      if (existingEntry) return existingEntry;

      const wallet = await this.getOrCreateWallet(tx, params.customerId);
      const newBalance = Number(wallet.balance) + params.amount;

      const entry = await tx.prepaidWalletLedgerEntry.create({
        data: {
          walletId: wallet.id,
          entryType: 'DEPOSIT',
          amount: params.amount,
          balanceAfter: newBalance,
          method: params.method,
          reference: params.reference ?? `${params.method} deposit`,
          createdById: params.actor.userId,
          deviceId: params.actor.deviceId,
          clientEntryId: params.clientEntryId,
        },
      });
      await tx.prepaidWallet.update({ where: { id: wallet.id }, data: { balance: newBalance } });

      await this.audit.record({
        branchId: params.actor.branchId,
        userId: params.actor.userId,
        deviceId: params.actor.deviceId,
        action: 'PREPAID_DEPOSIT',
        entityType: 'PrepaidWallet',
        entityId: wallet.id,
        afterSnapshot: { amount: params.amount, newBalance },
      });

      return entry;
    });
  }

  /**
   * Debits the wallet as part of a wash payment. Must run inside the same
   * transaction as the wash-order completion. The non-negative-balance
   * invariant is enforced here (application layer) and mirrored by a DB
   * CHECK constraint on prepaid_wallets.balance as defense-in-depth.
   * Idempotent per clientEntryId: a retried debit with the same key
   * returns the original ledger entry rather than debiting twice.
   */
  async debitForWash(
    tx: Tx,
    params: { customerId: string; amount: number; washOrderId: string; clientEntryId: string; actorId: string; deviceId?: string },
  ) {
    const existingEntry = await tx.prepaidWalletLedgerEntry.findUnique({
      where: { clientEntryId: params.clientEntryId },
    });
    if (existingEntry) return existingEntry;

    const wallet = await tx.prepaidWallet.findUnique({ where: { customerId: params.customerId } });
    if (!wallet) throw new NotFoundException('Customer has no prepaid wallet');
    if (Number(wallet.balance) < params.amount) {
      throw new BadRequestException(`Insufficient prepaid balance: available ${wallet.balance}, requested ${params.amount}`);
    }

    const newBalance = Number(wallet.balance) - params.amount;
    const entry = await tx.prepaidWalletLedgerEntry.create({
      data: {
        walletId: wallet.id,
        entryType: 'DEBIT',
        amount: -params.amount,
        balanceAfter: newBalance,
        reference: `Wash ${params.washOrderId}`,
        createdById: params.actorId,
        deviceId: params.deviceId,
        clientEntryId: params.clientEntryId,
      },
    });
    await tx.prepaidWallet.update({ where: { id: wallet.id }, data: { balance: newBalance } });
    return entry;
  }

  /** Compensating credit when a wallet-paid wash is voided — the ledger stays append-only. */
  async refundToWallet(
    tx: Tx,
    params: { customerId: string; amount: number; reference: string; clientEntryId: string; actorId: string; deviceId?: string },
  ) {
    const existingEntry = await tx.prepaidWalletLedgerEntry.findUnique({ where: { clientEntryId: params.clientEntryId } });
    if (existingEntry) return existingEntry;

    const wallet = await this.getOrCreateWallet(tx, params.customerId);
    const newBalance = Number(wallet.balance) + params.amount;
    const entry = await tx.prepaidWalletLedgerEntry.create({
      data: {
        walletId: wallet.id,
        entryType: 'ADJUSTMENT',
        amount: params.amount,
        balanceAfter: newBalance,
        reference: params.reference,
        createdById: params.actorId,
        deviceId: params.deviceId,
        clientEntryId: params.clientEntryId,
      },
    });
    await tx.prepaidWallet.update({ where: { id: wallet.id }, data: { balance: newBalance } });
    return entry;
  }

  /** Compensating credit when a package-paid wash is voided — gives the wash back to the purchase. */
  async refundPackageUsage(tx: Tx, purchaseId: string) {
    return tx.prepaidPackagePurchase.update({ where: { id: purchaseId }, data: { remainingCount: { increment: 1 } } });
  }

  async walletBalance(customerId: string): Promise<number> {
    const wallet = await this.prisma.prepaidWallet.findUnique({ where: { customerId } });
    return wallet ? Number(wallet.balance) : 0;
  }

  async listPackages(activeOnly = true) {
    return this.prisma.prepaidPackage.findMany({ where: activeOnly ? { active: true } : undefined });
  }

  /** Idempotent on params.id (client UUID) so an offline-queued retry never duplicates a purchase. */
  async purchasePackage(params: {
    id?: string;
    customerId: string;
    packageId: string;
    vehicleId?: string;
    actor: AuthenticatedUser;
  }) {
    if (params.id) {
      const existing = await this.prisma.prepaidPackagePurchase.findUnique({ where: { id: params.id } });
      if (existing) return existing;
    }

    const pkg = await this.prisma.prepaidPackage.findUniqueOrThrow({ where: { id: params.packageId } });
    if (pkg.applicableScope === 'SPECIFIC_VEHICLE' && !params.vehicleId) {
      throw new BadRequestException('This package requires a specific vehicle to be selected');
    }

    const purchase = await this.prisma.prepaidPackagePurchase.create({
      data: {
        id: params.id,
        packageId: pkg.id,
        customerId: params.customerId,
        vehicleId: params.vehicleId,
        expiresAt: new Date(Date.now() + pkg.validityDays * 86_400_000),
        remainingCount: pkg.washCount,
      },
    });

    await this.audit.record({
      branchId: params.actor.branchId,
      userId: params.actor.userId,
      deviceId: params.actor.deviceId,
      action: 'PREPAID_PACKAGE_PURCHASED',
      entityType: 'PrepaidPackagePurchase',
      entityId: purchase.id,
      afterSnapshot: purchase,
    });

    return purchase;
  }

  /** Finds the first active, unexpired purchase covering this service's tier for this vehicle/customer. */
  async findApplicablePurchase(tx: Tx, customerId: string, vehicleId: string, tier: string) {
    const purchases = await tx.prepaidPackagePurchase.findMany({
      where: {
        customerId,
        expiresAt: { gt: new Date() },
        remainingCount: { gt: 0 },
        OR: [{ vehicleId: null }, { vehicleId }],
      },
      include: { package: true },
      orderBy: { expiresAt: 'asc' },
    });
    return purchases.find((p) => p.package.eligibleTiers.length === 0 || p.package.eligibleTiers.includes(tier)) ?? null;
  }

  /** Idempotent per clientEntryId, same pattern as debitForWash. */
  async useForWash(
    tx: Tx,
    params: { purchaseId: string; washOrderId: string; vehicleId: string; clientEntryId: string; actorId: string },
  ) {
    const existingEntry = await tx.prepaidPackageUsage.findUnique({ where: { clientEntryId: params.clientEntryId } });
    if (existingEntry) return existingEntry;

    const purchase = await tx.prepaidPackagePurchase.findUniqueOrThrow({ where: { id: params.purchaseId } });
    if (purchase.remainingCount <= 0) throw new ConflictException('This package has no washes remaining');

    const usage = await tx.prepaidPackageUsage.create({
      data: {
        purchaseId: purchase.id,
        washOrderId: params.washOrderId,
        vehicleId: params.vehicleId,
        usedById: params.actorId,
        clientEntryId: params.clientEntryId,
      },
    });
    await tx.prepaidPackagePurchase.update({
      where: { id: purchase.id },
      data: { remainingCount: { decrement: 1 } },
    });
    return usage;
  }

  async customerOverview(customerId: string) {
    const [wallet, purchases] = await Promise.all([
      this.prisma.prepaidWallet.findUnique({ where: { customerId } }),
      this.prisma.prepaidPackagePurchase.findMany({
        where: { customerId, expiresAt: { gt: new Date() } },
        include: { package: true },
      }),
    ]);
    return { balance: wallet ? Number(wallet.balance) : 0, packages: purchases };
  }

  /** Read by the client to enforce the offline safe-cached-limit UX before it ever calls this endpoint. */
  offlinePolicy(freshnessWindowHours: number, perTransactionCap: number) {
    return { freshnessWindowHours, perTransactionCap };
  }
}
