import { describe, it, expect, beforeEach, vi } from 'vitest';
import { LoyaltyService } from './loyalty.service.js';
import { monthStart, addMonths } from '../../common/month.js';

interface LedgerRow {
  id: string;
  vehicleId: string;
  washOrderId: string | null;
  eventType: string;
  periodMonth: Date;
  createdById: string;
  deviceId?: string;
  notes?: string;
}

interface RewardRow {
  id: string;
  vehicleId: string;
  earnedMonth: Date;
  validMonth: Date;
  status: 'AVAILABLE' | 'REDEEMED' | 'EXPIRED' | 'REVOKED';
  earnedFromLedgerId: string;
  redeemedWashOrderId?: string | null;
  redeemedAt?: Date | null;
  expiredAt?: Date | null;
}

/** Minimal in-memory stand-in for a Prisma.TransactionClient, scoped to what LoyaltyService calls. */
function makeFakeTx() {
  const ledger: LedgerRow[] = [];
  const rewards: RewardRow[] = [];
  let ledgerSeq = 0;
  let rewardSeq = 0;

  const matches = (row: LedgerRow, where: any) =>
    (where.vehicleId === undefined || row.vehicleId === where.vehicleId) &&
    (where.eventType === undefined || row.eventType === where.eventType) &&
    (where.periodMonth === undefined || row.periodMonth.getTime() === where.periodMonth.getTime());

  const tx = {
    loyaltyLedgerEntry: {
      findMany: vi.fn(async ({ where }: any) => ledger.filter((r) => matches(r, where))),
      findUnique: vi.fn(async ({ where }: any) => {
        const key = where.washOrderId_eventType;
        return ledger.find((r) => r.washOrderId === key.washOrderId && r.eventType === key.eventType) ?? null;
      }),
      create: vi.fn(async ({ data }: any) => {
        const row: LedgerRow = { id: `ll-${++ledgerSeq}`, ...data };
        ledger.push(row);
        return row;
      }),
    },
    loyaltyReward: {
      findFirst: vi.fn(async ({ where }: any) =>
        rewards.find(
          (r) =>
            (where.vehicleId === undefined || r.vehicleId === where.vehicleId) &&
            (where.earnedMonth === undefined || r.earnedMonth.getTime() === where.earnedMonth.getTime()) &&
            (where.status === undefined || r.status === where.status) &&
            (where.validMonth === undefined || r.validMonth.getTime() === where.validMonth.getTime()),
        ) ?? null,
      ),
      create: vi.fn(async ({ data }: any) => {
        const row: RewardRow = { id: `rw-${++rewardSeq}`, status: 'AVAILABLE', ...data };
        rewards.push(row);
        return row;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const row = rewards.find((r) => r.id === where.id)!;
        Object.assign(row, data);
        return row;
      }),
    },
  };

  return { tx, ledger, rewards };
}

function buildService() {
  const prisma = { $transaction: vi.fn() } as any;
  const audit = { record: vi.fn(async () => undefined) } as any;
  return new LoyaltyService(prisma, audit);
}

const JAN = new Date(Date.UTC(2026, 0, 15)); // 2026-01-15
const FEB = new Date(Date.UTC(2026, 1, 10)); // 2026-02-10

describe('LoyaltyService', () => {
  let service: LoyaltyService;

  beforeEach(() => {
    service = buildService();
  });

  it('does not earn a reward before the 5th qualifying wash', async () => {
    const { tx } = makeFakeTx();
    for (let i = 1; i <= 4; i++) {
      const result = await service.creditQualifyingWash(tx as any, {
        vehicleId: 'veh-1',
        washOrderId: `wash-${i}`,
        at: JAN,
        actorId: 'user-1',
      });
      expect(result.earned).toBe(false);
      expect(result.count).toBe(i);
    }
  });

  it('earns exactly one reward on the 5th qualifying wash, valid the following month', async () => {
    const { tx } = makeFakeTx();
    for (let i = 1; i <= 4; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    const fifth = await service.creditQualifyingWash(tx as any, {
      vehicleId: 'veh-1',
      washOrderId: 'wash-5',
      at: JAN,
      actorId: 'u',
    });
    expect(fifth.earned).toBe(true);
    expect(fifth.count).toBe(5);

    const reward = await service.findAvailableReward(tx as any, 'veh-1', addMonths(JAN, 1));
    expect(reward).toBeTruthy();
    expect(reward!.validMonth.getTime()).toBe(monthStart(addMonths(JAN, 1)).getTime());
  });

  it('does not earn a second reward from washes 6-10 in the same month (max one reward per month)', async () => {
    const { tx, rewards } = makeFakeTx();
    for (let i = 1; i <= 8; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    expect(rewards.length).toBe(1);
  });

  it('keeps loyalty progress separate per vehicle even for the same customer', async () => {
    const { tx } = makeFakeTx();
    for (let i = 1; i <= 3; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-A', washOrderId: `a-${i}`, at: JAN, actorId: 'u' });
    }
    for (let i = 1; i <= 2; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-B', washOrderId: `b-${i}`, at: JAN, actorId: 'u' });
    }
    expect(await service.qualifyingCount(tx as any, 'veh-A', JAN)).toBe(3);
    expect(await service.qualifyingCount(tx as any, 'veh-B', JAN)).toBe(2);
  });

  it('resets progress at the start of the following month', async () => {
    const { tx } = makeFakeTx();
    for (let i = 1; i <= 4; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `jan-${i}`, at: JAN, actorId: 'u' });
    }
    expect(await service.qualifyingCount(tx as any, 'veh-1', JAN)).toBe(4);
    expect(await service.qualifyingCount(tx as any, 'veh-1', FEB)).toBe(0);
  });

  it('is idempotent: crediting the same wash twice only counts once', async () => {
    const { tx } = makeFakeTx();
    await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: 'wash-1', at: JAN, actorId: 'u' });
    const second = await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: 'wash-1', at: JAN, actorId: 'u' });
    expect(second.count).toBe(1);
  });

  it('reversing a wash below the 5th drops the count and revokes an AVAILABLE reward', async () => {
    const { tx, rewards } = makeFakeTx();
    for (let i = 1; i <= 5; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    expect(rewards[0].status).toBe('AVAILABLE');

    const result = await service.reverseWash(tx as any, { washOrderId: 'wash-5', actorId: 'u', reason: 'refund' });
    expect(result.count).toBe(4);
    expect(result.downgradedRewardId).toBe(rewards[0].id);
    expect(rewards[0].status).toBe('REVOKED');
  });

  it('reversing a wash that keeps the count at/above 5 does not touch the reward', async () => {
    const { tx, rewards } = makeFakeTx();
    for (let i = 1; i <= 6; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    const result = await service.reverseWash(tx as any, { washOrderId: 'wash-6', actorId: 'u', reason: 'refund' });
    expect(result.count).toBe(5);
    expect(rewards[0].status).toBe('AVAILABLE');
  });

  it('flags for admin review rather than auto-unwinding when the earned reward was already redeemed elsewhere', async () => {
    const { tx, rewards } = makeFakeTx();
    for (let i = 1; i <= 5; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    await service.redeemReward(tx as any, { rewardId: rewards[0].id, washOrderId: 'later-free-wash', actorId: 'u' });
    expect(rewards[0].status).toBe('REDEEMED');

    const result = await service.reverseWash(tx as any, { washOrderId: 'wash-5', actorId: 'u', reason: 'refund' });
    expect(result.flaggedForReview).toBe(true);
    // The already-redeemed reward is left alone — not silently reversed.
    expect(rewards[0].status).toBe('REDEEMED');
  });

  it('reversing a wash twice is idempotent (no double reversal, no double count drop)', async () => {
    const { tx } = makeFakeTx();
    for (let i = 1; i <= 5; i++) {
      await service.creditQualifyingWash(tx as any, { vehicleId: 'veh-1', washOrderId: `wash-${i}`, at: JAN, actorId: 'u' });
    }
    await service.reverseWash(tx as any, { washOrderId: 'wash-5', actorId: 'u', reason: 'refund' });
    const secondReversal = await service.reverseWash(tx as any, { washOrderId: 'wash-5', actorId: 'u', reason: 'refund again' });
    expect(secondReversal.count).toBe(4);
  });

  it('a free (loyalty-paid) wash was never credited, so reversing it is a safe no-op', async () => {
    const { tx } = makeFakeTx();
    const result = await service.reverseWash(tx as any, { washOrderId: 'never-credited', actorId: 'u', reason: 'n/a' });
    expect(result.count).toBe(0);
    expect(result.flaggedForReview).toBe(false);
  });
});
