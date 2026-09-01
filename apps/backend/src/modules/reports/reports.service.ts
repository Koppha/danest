import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  async summary(branchId: string, from: Date, to: Date) {
    const payments = await this.prisma.payment.findMany({
      where: { voided: false, completedAt: { gte: from, lt: to }, washOrder: { branchId } },
      include: { components: { include: { paymentMethod: true } }, washOrder: { include: { items: { include: { service: true } } } } },
    });

    const totalSales = payments.reduce((sum, p) => sum + Number(p.totalAmount), 0);
    const totalCompletedWashes = payments.length;
    const totalFreeWashes = payments.filter((p) => p.components.some((c) => c.paymentMethod.code === 'LOYALTY_FREE_WASH')).length;

    const salesByMethod: Record<string, number> = {};
    for (const p of payments) {
      for (const c of p.components) {
        salesByMethod[c.paymentMethod.code] = (salesByMethod[c.paymentMethod.code] ?? 0) + Number(c.amount);
      }
    }

    const washesByService: Record<string, number> = {};
    for (const p of payments) {
      for (const item of p.washOrder.items) {
        if (item.itemType !== 'SERVICE') continue;
        const name = item.nameSnapshot;
        washesByService[name] = (washesByService[name] ?? 0) + 1;
      }
    }

    const deposits = await this.prisma.prepaidWalletLedgerEntry.aggregate({
      where: { entryType: 'DEPOSIT', createdAt: { gte: from, lt: to }, wallet: { customer: { branchId } } },
      _sum: { amount: true },
    });

    const expenses = await this.prisma.expense.aggregate({
      where: { branchId, createdAt: { gte: from, lt: to } },
      _sum: { amount: true },
    });

    const collections = await this.prisma.cashCollection.findMany({
      where: { branchId, createdAt: { gte: from, lt: to } },
    });
    const cashCollected = collections.reduce((sum, c) => sum + Number(c.countedCash), 0);
    const cashShortages = collections.filter((c) => c.result === 'SHORT').reduce((sum, c) => sum + Math.abs(Number(c.variance)), 0);
    const cashOverages = collections.filter((c) => c.result === 'OVER').reduce((sum, c) => sum + Number(c.variance), 0);

    const totalExpenses = Number(expenses._sum.amount ?? 0);
    const totalDeposits = Number(deposits._sum.amount ?? 0);

    return {
      period: { from, to },
      totalSales,
      totalCompletedWashes,
      totalFreeWashes,
      totalPrepaidDeposits: totalDeposits,
      totalExpenses,
      netOperatingCash: totalSales + totalDeposits - totalExpenses,
      salesByMethod,
      washesByService,
      cashCollected,
      cashShortages,
      cashOverages,
    };
  }

  async transactions(branchId: string, from: Date, to: Date) {
    return this.prisma.payment.findMany({
      where: { completedAt: { gte: from, lt: to }, washOrder: { branchId } },
      include: {
        components: { include: { paymentMethod: true } },
        washOrder: { include: { vehicle: true, customer: true } },
      },
      orderBy: { completedAt: 'desc' },
    });
  }

  toCsv(rows: Record<string, unknown>[]): string {
    if (rows.length === 0) return '';
    const headers = Object.keys(rows[0]);
    const escape = (v: unknown) => `"${String(v ?? '').replace(/"/g, '""')}"`;
    const lines = [headers.join(','), ...rows.map((r) => headers.map((h) => escape(r[h])).join(','))];
    return lines.join('\n');
  }
}
