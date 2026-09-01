import { describe, it, expect, vi } from 'vitest';
import { BadRequestException, ConflictException } from '@nestjs/common';
import { PrepaidService } from './prepaid.service.js';

interface WalletRow {
  id: string;
  customerId: string;
  balance: number;
}
interface LedgerRow {
  id: string;
  walletId: string;
  entryType: string;
  amount: number;
  balanceAfter: number;
  clientEntryId: string;
}
interface PurchaseRow {
  id: string;
  packageId: string;
  customerId: string;
  vehicleId: string | null;
  expiresAt: Date;
  remainingCount: number;
  package: { eligibleTiers: string[] };
}
interface UsageRow {
  id: string;
  purchaseId: string;
  washOrderId: string;
  vehicleId: string;
  clientEntryId: string;
}

function makeFakeTx(seedWallets: WalletRow[] = [], seedPurchases: PurchaseRow[] = []) {
  const wallets = [...seedWallets];
  const ledger: LedgerRow[] = [];
  const purchases = [...seedPurchases];
  const usage: UsageRow[] = [];
  let ledgerSeq = 0;
  let usageSeq = 0;

  const tx = {
    prepaidWallet: {
      findUnique: vi.fn(async ({ where }: any) => wallets.find((w) => w.customerId === where.customerId) ?? null),
      create: vi.fn(async ({ data }: any) => {
        const row: WalletRow = { id: `wl-${wallets.length + 1}`, balance: 0, ...data };
        wallets.push(row);
        return row;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const row = wallets.find((w) => w.id === where.id)!;
        if (data.balance !== undefined) row.balance = data.balance;
        return row;
      }),
    },
    prepaidWalletLedgerEntry: {
      findUnique: vi.fn(async ({ where }: any) => ledger.find((l) => l.clientEntryId === where.clientEntryId) ?? null),
      create: vi.fn(async ({ data }: any) => {
        const row: LedgerRow = { id: `led-${++ledgerSeq}`, ...data };
        ledger.push(row);
        return row;
      }),
    },
    prepaidPackagePurchase: {
      findMany: vi.fn(async ({ where }: any) =>
        purchases.filter(
          (p) =>
            p.customerId === where.customerId &&
            p.expiresAt > new Date() &&
            p.remainingCount > 0 &&
            (p.vehicleId === null || p.vehicleId === where.OR[1].vehicleId),
        ),
      ),
      findUniqueOrThrow: vi.fn(async ({ where }: any) => {
        const p = purchases.find((x) => x.id === where.id);
        if (!p) throw new Error('not found');
        return p;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const p = purchases.find((x) => x.id === where.id)!;
        if (data.remainingCount?.decrement) p.remainingCount -= data.remainingCount.decrement;
        return p;
      }),
    },
    prepaidPackageUsage: {
      findUnique: vi.fn(async ({ where }: any) => usage.find((u) => u.clientEntryId === where.clientEntryId) ?? null),
      create: vi.fn(async ({ data }: any) => {
        const row: UsageRow = { id: `use-${++usageSeq}`, ...data };
        usage.push(row);
        return row;
      }),
    },
  };

  return { tx, wallets, ledger, purchases, usage };
}

function buildService() {
  const prisma = {} as any;
  const audit = { record: vi.fn(async () => undefined) } as any;
  return new PrepaidService(prisma, audit);
}

describe('PrepaidService.debitForWash', () => {
  it('debits the wallet and never lets the balance go negative', async () => {
    const { tx, wallets } = makeFakeTx([{ id: 'wl-1', customerId: 'cust-1', balance: 100 }]);
    const service = buildService();

    const entry = await service.debitForWash(tx as any, {
      customerId: 'cust-1',
      amount: 40,
      washOrderId: 'wash-1',
      clientEntryId: 'ce-1',
      actorId: 'u',
    });

    expect(entry.amount).toBe(-40);
    expect(wallets[0].balance).toBe(60);
  });

  it('rejects a debit larger than the available balance', async () => {
    const { tx } = makeFakeTx([{ id: 'wl-1', customerId: 'cust-1', balance: 30 }]);
    const service = buildService();

    await expect(
      service.debitForWash(tx as any, { customerId: 'cust-1', amount: 40, washOrderId: 'wash-1', clientEntryId: 'ce-1', actorId: 'u' }),
    ).rejects.toThrow(BadRequestException);
  });

  it('is idempotent: retrying the same clientEntryId does not debit twice', async () => {
    const { tx, wallets } = makeFakeTx([{ id: 'wl-1', customerId: 'cust-1', balance: 100 }]);
    const service = buildService();

    await service.debitForWash(tx as any, { customerId: 'cust-1', amount: 40, washOrderId: 'wash-1', clientEntryId: 'ce-1', actorId: 'u' });
    await service.debitForWash(tx as any, { customerId: 'cust-1', amount: 40, washOrderId: 'wash-1', clientEntryId: 'ce-1', actorId: 'u' });

    expect(wallets[0].balance).toBe(60); // not 20 — second call was a no-op
  });
});

describe('PrepaidService package usage', () => {
  const purchase: PurchaseRow = {
    id: 'pp-1',
    packageId: 'pk-1',
    customerId: 'cust-1',
    vehicleId: null,
    expiresAt: new Date(Date.now() + 86_400_000),
    remainingCount: 2,
    package: { eligibleTiers: ['standard', 'deluxe'] },
  };

  it('finds an applicable purchase covering the requested tier', async () => {
    const { tx } = makeFakeTx([], [purchase]);
    const service = buildService();
    const found = await service.findApplicablePurchase(tx as any, 'cust-1', 'veh-1', 'standard');
    expect(found?.id).toBe('pp-1');
  });

  it('does not match a purchase whose eligible tiers exclude the requested one', async () => {
    const { tx } = makeFakeTx([], [{ ...purchase, package: { eligibleTiers: ['premium'] } }]);
    const service = buildService();
    const found = await service.findApplicablePurchase(tx as any, 'cust-1', 'veh-1', 'standard');
    expect(found).toBeNull();
  });

  it('decrements remainingCount on use and is idempotent per clientEntryId', async () => {
    const { tx, purchases } = makeFakeTx([], [{ ...purchase }]);
    const service = buildService();

    await service.useForWash(tx as any, { purchaseId: 'pp-1', washOrderId: 'wash-1', vehicleId: 'veh-1', clientEntryId: 'ce-1', actorId: 'u' });
    expect(purchases[0].remainingCount).toBe(1);

    await service.useForWash(tx as any, { purchaseId: 'pp-1', washOrderId: 'wash-1', vehicleId: 'veh-1', clientEntryId: 'ce-1', actorId: 'u' });
    expect(purchases[0].remainingCount).toBe(1); // second call was a no-op
  });

  it('rejects use when no washes remain', async () => {
    const { tx } = makeFakeTx([], [{ ...purchase, remainingCount: 0 }]);
    const service = buildService();
    await expect(
      service.useForWash(tx as any, { purchaseId: 'pp-1', washOrderId: 'wash-1', vehicleId: 'veh-1', clientEntryId: 'ce-1', actorId: 'u' }),
    ).rejects.toThrow(ConflictException);
  });
});
