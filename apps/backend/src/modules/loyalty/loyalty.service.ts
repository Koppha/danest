import { Injectable } from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { monthStart, addMonths } from '../../common/month.js';

type Tx = Prisma.TransactionClient;

export interface CreditResult {
  earned: boolean;
  count: number;
  rewardId?: string;
}

export interface ReverseResult {
  count: number;
  downgradedRewardId?: string;
  flaggedForReview: boolean;
}

/**
 * The loyalty ledger is append-only and is the single source of truth.
 * "Qualifying count" is never stored as a mutable counter — it is always
 * recomputed live from loyalty_ledger, which is what makes offline-sync
 * replay and reversal walk-backs safe (re-applying the same event twice is
 * a no-op thanks to the (washOrderId, eventType) unique constraint).
 */
@Injectable()
export class LoyaltyService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async qualifyingCount(tx: Tx, vehicleId: string, periodMonth: Date): Promise<number> {
    const period = monthStart(periodMonth);
    const [credited, reversed] = await Promise.all([
      tx.loyaltyLedgerEntry.findMany({
        where: { vehicleId, periodMonth: period, eventType: 'WASH_CREDITED' },
        select: { washOrderId: true },
      }),
      tx.loyaltyLedgerEntry.findMany({
        where: { vehicleId, periodMonth: period, eventType: 'WASH_REVERSED' },
        select: { washOrderId: true },
      }),
    ]);
    const reversedIds = new Set(reversed.map((r) => r.washOrderId));
    return credited.filter((c) => !reversedIds.has(c.washOrderId)).length;
  }

  /**
   * Credits one qualifying wash for a vehicle. Idempotent per wash: a
   * duplicate call for the same washOrderId is a no-op (unique constraint
   * on (washOrderId, eventType) means the second insert conflicts and we
   * just recompute/return the current state instead of double-crediting).
   */
  async creditQualifyingWash(
    tx: Tx,
    params: { vehicleId: string; washOrderId: string; at: Date; actorId: string; deviceId?: string },
  ): Promise<CreditResult> {
    const period = monthStart(params.at);

    const alreadyCredited = await tx.loyaltyLedgerEntry.findUnique({
      where: { washOrderId_eventType: { washOrderId: params.washOrderId, eventType: 'WASH_CREDITED' } },
    });
    let creditEntry = alreadyCredited;
    if (!creditEntry) {
      creditEntry = await tx.loyaltyLedgerEntry.create({
        data: {
          vehicleId: params.vehicleId,
          washOrderId: params.washOrderId,
          eventType: 'WASH_CREDITED',
          periodMonth: period,
          createdById: params.actorId,
          deviceId: params.deviceId,
        },
      });
    }

    const count = await this.qualifyingCount(tx, params.vehicleId, period);

    const alreadyEarnedThisMonth = await tx.loyaltyReward.findFirst({
      where: { vehicleId: params.vehicleId, earnedMonth: period },
    });

    if (count === 5 && !alreadyEarnedThisMonth) {
      const rewardEarnedEntry = await tx.loyaltyLedgerEntry.create({
        data: {
          vehicleId: params.vehicleId,
          washOrderId: params.washOrderId,
          eventType: 'REWARD_EARNED',
          periodMonth: period,
          createdById: params.actorId,
          deviceId: params.deviceId,
          notes: 'Five qualifying washes in the month',
        },
      });
      const reward = await tx.loyaltyReward.create({
        data: {
          vehicleId: params.vehicleId,
          earnedMonth: period,
          validMonth: addMonths(period, 1),
          earnedFromLedgerId: rewardEarnedEntry.id,
        },
      });
      return { earned: true, count, rewardId: reward.id };
    }

    return { earned: false, count };
  }

  /**
   * Walks back a wash reversal (refund/void). If the reward this wash
   * helped earn is still AVAILABLE, it's revoked. If it was already
   * REDEEMED against a different wash, we do not auto-unwind that other
   * wash — that's a business judgment call — instead we flag it via a
   * MANAGER_ADJUSTMENT ledger entry for the admin conflict/review queue.
   */
  async reverseWash(
    tx: Tx,
    params: { washOrderId: string; actorId: string; deviceId?: string; reason: string },
  ): Promise<ReverseResult> {
    const creditEntry = await tx.loyaltyLedgerEntry.findUnique({
      where: { washOrderId_eventType: { washOrderId: params.washOrderId, eventType: 'WASH_CREDITED' } },
    });
    // Wash was never a qualifying credited wash (e.g. paid entirely by loyalty free wash) — nothing to reverse.
    if (!creditEntry) return { count: 0, flaggedForReview: false };

    const alreadyReversed = await tx.loyaltyLedgerEntry.findUnique({
      where: { washOrderId_eventType: { washOrderId: params.washOrderId, eventType: 'WASH_REVERSED' } },
    });
    if (!alreadyReversed) {
      await tx.loyaltyLedgerEntry.create({
        data: {
          vehicleId: creditEntry.vehicleId,
          washOrderId: params.washOrderId,
          eventType: 'WASH_REVERSED',
          periodMonth: creditEntry.periodMonth,
          createdById: params.actorId,
          deviceId: params.deviceId,
          notes: params.reason,
        },
      });
    }

    const count = await this.qualifyingCount(tx, creditEntry.vehicleId, creditEntry.periodMonth);

    const reward = await tx.loyaltyReward.findFirst({
      where: { vehicleId: creditEntry.vehicleId, earnedMonth: creditEntry.periodMonth },
    });

    if (!reward || count >= 5) return { count, flaggedForReview: false };

    if (reward.status === 'AVAILABLE') {
      await tx.loyaltyReward.update({ where: { id: reward.id }, data: { status: 'REVOKED', expiredAt: new Date() } });
      await tx.loyaltyLedgerEntry.create({
        data: {
          vehicleId: creditEntry.vehicleId,
          eventType: 'MANAGER_ADJUSTMENT',
          periodMonth: creditEntry.periodMonth,
          createdById: params.actorId,
          deviceId: params.deviceId,
          notes: `Reward revoked: wash ${params.washOrderId} reversed, dropping the vehicle below 5 qualifying washes`,
        },
      });
      return { count, downgradedRewardId: reward.id, flaggedForReview: false };
    }

    if (reward.status === 'REDEEMED') {
      await tx.loyaltyLedgerEntry.create({
        data: {
          vehicleId: creditEntry.vehicleId,
          eventType: 'MANAGER_ADJUSTMENT',
          periodMonth: creditEntry.periodMonth,
          createdById: params.actorId,
          deviceId: params.deviceId,
          notes: `NEEDS REVIEW: reward ${reward.id} was already redeemed against wash ${reward.redeemedWashOrderId}, but the wash that earned it (${params.washOrderId}) was just reversed`,
        },
      });
      return { count, flaggedForReview: true };
    }

    return { count, flaggedForReview: false };
  }

  async findAvailableReward(tx: Tx, vehicleId: string, asOf: Date) {
    return tx.loyaltyReward.findFirst({
      where: { vehicleId, status: 'AVAILABLE', validMonth: monthStart(asOf) },
    });
  }

  async redeemReward(tx: Tx, params: { rewardId: string; washOrderId: string; actorId: string; deviceId?: string }) {
    const reward = await tx.loyaltyReward.update({
      where: { id: params.rewardId },
      data: { status: 'REDEEMED', redeemedWashOrderId: params.washOrderId, redeemedAt: new Date() },
    });
    await tx.loyaltyLedgerEntry.create({
      data: {
        vehicleId: reward.vehicleId,
        washOrderId: params.washOrderId,
        eventType: 'REWARD_REDEEMED',
        periodMonth: monthStart(new Date()),
        createdById: params.actorId,
        deviceId: params.deviceId,
      },
    });
    return reward;
  }

  async manualAdjustment(params: { vehicleId: string; note: string; actorId: string; deviceId?: string; branchId?: string }) {
    await this.prisma.loyaltyLedgerEntry.create({
      data: {
        vehicleId: params.vehicleId,
        eventType: 'MANAGER_ADJUSTMENT',
        periodMonth: monthStart(new Date()),
        createdById: params.actorId,
        deviceId: params.deviceId,
        notes: params.note,
      },
    });
    await this.audit.record({
      branchId: params.branchId,
      userId: params.actorId,
      deviceId: params.deviceId,
      action: 'LOYALTY_MANUAL_ADJUSTMENT',
      entityType: 'Vehicle',
      entityId: params.vehicleId,
      afterSnapshot: { note: params.note },
    });
  }

  async summaryForVehicle(vehicleId: string, asOf = new Date()) {
    const period = monthStart(asOf);
    const [count, reward] = await Promise.all([
      this.qualifyingCount(this.prisma as unknown as Tx, vehicleId, period),
      this.findAvailableReward(this.prisma as unknown as Tx, vehicleId, asOf),
    ]);
    return { periodMonth: period, qualifyingCount: count, remaining: Math.max(0, 5 - count), availableReward: reward };
  }

  /** Scheduled (or manually invoked): expires AVAILABLE rewards past their valid month. */
  async expireStaleRewards(asOf = new Date()) {
    const period = monthStart(asOf);
    const systemUser = await this.prisma.user.findUniqueOrThrow({ where: { username: 'system' } });
    const stale = await this.prisma.loyaltyReward.findMany({
      where: { status: 'AVAILABLE', validMonth: { lt: period } },
    });
    for (const reward of stale) {
      await this.prisma.$transaction(async (tx) => {
        await tx.loyaltyReward.update({ where: { id: reward.id }, data: { status: 'EXPIRED', expiredAt: new Date() } });
        await tx.loyaltyLedgerEntry.create({
          data: {
            vehicleId: reward.vehicleId,
            eventType: 'REWARD_EXPIRED',
            periodMonth: reward.validMonth,
            createdById: systemUser.id,
            notes: 'Not redeemed before month end',
          },
        });
      });
    }
    return stale.length;
  }
}
