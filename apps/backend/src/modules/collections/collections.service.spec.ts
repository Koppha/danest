import { describe, it, expect, vi } from 'vitest';
import { BadRequestException } from '@nestjs/common';
import { CollectionsService } from './collections.service.js';

function makeFakePrisma(opts: {
  lastCollectionEnd?: Date;
  cashSales?: number;
  cashRefunds?: number;
  cashDeposits?: number;
  cashExpenses?: number;
}) {
  const collections: any[] = [];
  const prisma = {
    cashCollection: {
      findFirst: vi.fn(async () => (opts.lastCollectionEnd ? { periodEndAt: opts.lastCollectionEnd } : null)),
      findUnique: vi.fn(async ({ where }: any) => collections.find((c) => c.id === where.id) ?? null),
      create: vi.fn(async ({ data }: any) => {
        const row = { id: data.id ?? `cc-${collections.length + 1}`, ...data };
        collections.push(row);
        return row;
      }),
    },
    paymentComponent: {
      findMany: vi.fn(async ({ where }: any) => {
        if (where.payment.voided === true) return [{ amount: opts.cashRefunds ?? 0 }];
        if (where.paymentMethod.code === 'CASH') return [{ amount: opts.cashSales ?? 0 }];
        return []; // non-cash verification sums default to 0 for this test
      }),
    },
    prepaidWalletLedgerEntry: {
      findMany: vi.fn(async () => [{ amount: opts.cashDeposits ?? 0 }]),
    },
    expense: {
      findMany: vi.fn(async () => [{ amount: opts.cashExpenses ?? 0 }]),
    },
  } as any;
  return { prisma, collections };
}

const actor = { userId: 'u', branchId: 'branch-1', deviceId: 'd' } as any;

describe('CollectionsService', () => {
  it('computes expected cash as sales + deposits - refunds - expenses', async () => {
    const { prisma } = makeFakePrisma({ cashSales: 500, cashDeposits: 200, cashRefunds: 50, cashExpenses: 80 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);

    const breakdown = await service.computeExpected('branch-1');
    expect(breakdown.expected).toBe(500 + 200 - 50 - 80);
  });

  it('starts the period at the previous collection cut-off, not from the beginning of time', async () => {
    const cutoff = new Date('2026-08-01T00:00:00Z');
    const { prisma } = makeFakePrisma({ lastCollectionEnd: cutoff, cashSales: 100 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);

    const breakdown = await service.computeExpected('branch-1');
    expect(breakdown.periodStart.getTime()).toBe(cutoff.getTime());
  });

  it('marks the result MATCHED when counted cash equals expected, with no reason required', async () => {
    const { prisma } = makeFakePrisma({ cashSales: 1000 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);

    const { collection } = await service.confirm({ branchId: 'branch-1', countedCash: 1000, actor });
    expect(collection.result).toBe('MATCHED');
    expect(collection.variance).toBe(0);
  });

  it('requires a reason when counted cash is SHORT', async () => {
    const { prisma } = makeFakePrisma({ cashSales: 1000 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);

    await expect(service.confirm({ branchId: 'branch-1', countedCash: 900, actor })).rejects.toThrow(BadRequestException);
  });

  it('records SHORT/OVER correctly once a reason is given', async () => {
    const { prisma } = makeFakePrisma({ cashSales: 1000 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);

    const short = await service.confirm({ branchId: 'branch-1', countedCash: 900, varianceReason: 'till miscounted', actor });
    expect(short.collection.result).toBe('SHORT');
    expect(short.collection.variance).toBe(-100);

    const over = await service.confirm({ branchId: 'branch-1', countedCash: 1100, varianceReason: 'extra tip left in till', actor });
    expect(over.collection.result).toBe('OVER');
    expect(over.collection.variance).toBe(100);
  });

  it('is idempotent on a client-supplied id — a retried offline confirm does not duplicate', async () => {
    const { prisma, collections } = makeFakePrisma({ cashSales: 1000 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);
    const params = { id: 'client-uuid-1', branchId: 'branch-1', countedCash: 1000, actor } as any;

    const first = await service.confirm(params);
    const second = await service.confirm(params);

    expect(second.collection.id).toBe(first.collection.id);
    expect(collections).toHaveLength(1);
  });

  it('uses countedAt (when the attendant actually counted) as the period end, not "now"', async () => {
    const { prisma } = makeFakePrisma({ cashSales: 1000 });
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new CollectionsService(prisma, audit);
    const countedAt = '2026-08-15T12:00:00.000Z';

    const { collection } = await service.confirm({ branchId: 'branch-1', countedCash: 1000, actor, countedAt });

    expect(new Date(collection.periodEndAt).toISOString()).toBe(countedAt);
  });
});
