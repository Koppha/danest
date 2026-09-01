import { describe, it, expect, vi } from 'vitest';
import { BadRequestException } from '@nestjs/common';
import { ExpensesService } from './expenses.service.js';

function makeFakePrisma(original?: any) {
  const expenses = original ? [original] : [];
  const prisma = {
    expense: {
      findUnique: vi.fn(async ({ where }: any) => expenses.find((e) => e.id === where.id) ?? null),
      findUniqueOrThrow: vi.fn(async ({ where }: any) => expenses.find((e) => e.id === where.id)!),
      create: vi.fn(async ({ data }: any) => {
        const row = { id: data.id ?? `exp-${expenses.length + 1}`, ...data };
        expenses.push(row);
        return row;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const row = expenses.find((e) => e.id === where.id)!;
        Object.assign(row, data);
        return row;
      }),
    },
    $transaction: vi.fn(async (ops: any[]) => Promise.all(ops)),
  } as any;
  return { prisma, expenses };
}

const actor = { userId: 'u', branchId: 'branch-1', deviceId: 'd' } as any;

describe('ExpensesService.reverse', () => {
  it('creates a negative-amount reversal row rather than editing the original', async () => {
    const original = { id: 'exp-1', branchId: 'branch-1', categoryId: 'cat-1', amount: 220, paymentMethod: 'CASH', reversedByExpenseId: null };
    const { prisma, expenses } = makeFakePrisma(original);
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new ExpensesService(prisma, audit);

    const reversal = await service.reverse('exp-1', 'duplicate entry', actor);

    expect(Number(reversal.amount)).toBe(-220);
    expect(expenses[0].amount).toBe(220); // original untouched
    expect(expenses[0].reversedByExpenseId).toBe(reversal.id);
    // Net effect on any period sum that includes both rows is zero.
    expect(Number(expenses[0].amount) + Number(reversal.amount)).toBe(0);
  });

  it('refuses to reverse an expense that was already reversed', async () => {
    const original = { id: 'exp-1', branchId: 'branch-1', categoryId: 'cat-1', amount: 100, paymentMethod: 'CASH', reversedByExpenseId: 'exp-2' };
    const { prisma } = makeFakePrisma(original);
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new ExpensesService(prisma, audit);

    await expect(service.reverse('exp-1', 'again', actor)).rejects.toThrow(BadRequestException);
  });
});

describe('ExpensesService.create', () => {
  it('is idempotent on a client-supplied id — a retried offline create does not duplicate', async () => {
    const { prisma, expenses } = makeFakePrisma();
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new ExpensesService(prisma, audit);
    const dto = { id: 'client-uuid-1', categoryId: 'cat-1', description: 'Detergent', amount: 150, paymentMethod: 'CASH' } as any;

    const first = await service.create(dto, actor);
    const second = await service.create(dto, actor);

    expect(second.id).toBe(first.id);
    expect(expenses).toHaveLength(1);
    expect(audit.record).toHaveBeenCalledTimes(1); // second call short-circuited before recording again
  });
});
