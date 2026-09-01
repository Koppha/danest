import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { LoyaltyService } from '../loyalty/loyalty.service.js';
import { PrepaidService } from '../prepaid/prepaid.service.js';
import { SmsService } from '../sms/sms.service.js';
import type { PaymentComponentInput } from './dto/finish-wash.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

const QUALIFYING_METHODS = new Set(['CASH', 'CARD', 'MOBILE_MONEY', 'BANK_TRANSFER', 'WALLET', 'PACKAGE']);
const REFERENCE_REQUIRED_METHODS = new Set(['MOBILE_MONEY', 'BANK_TRANSFER']);

@Injectable()
export class PaymentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly loyalty: LoyaltyService,
    private readonly prepaid: PrepaidService,
    private readonly sms: SmsService,
  ) {}

  /**
   * The "Finish Wash & Send SMS" orchestration. Assumed to already be
   * wrapped by IdempotencyInterceptor at the controller layer (keyed on
   * `finish:{washOrderId}`) — the payment/loyalty/prepaid/sms unique
   * constraints below are defense-in-depth on top of that outer cache, not
   * the only idempotency guard.
   */
  async finishWash(washOrderId: string, components: PaymentComponentInput[], actor: AuthenticatedUser) {
    const washOrder = await this.prisma.washOrder.findUnique({
      where: { id: washOrderId },
      include: { items: { include: { service: true } }, payment: true },
    });
    if (!washOrder) throw new NotFoundException('Wash order not found');

    if (washOrder.status === 'COMPLETED') {
      // Already finished (defense-in-depth beyond the outer idempotency cache) — return the existing state, do nothing.
      return this.prisma.washOrder.findUniqueOrThrow({ where: { id: washOrderId }, include: { payment: { include: { components: true } } } });
    }
    if (washOrder.status === 'CANCELLED') throw new BadRequestException('This wash was cancelled and cannot be completed');

    const total = components.reduce((sum, c) => sum + c.amount, 0);
    if (Math.abs(total - Number(washOrder.totalAmount)) > 0.005) {
      throw new BadRequestException(
        `Payment components sum to ${total.toFixed(2)} but the wash total is ${Number(washOrder.totalAmount).toFixed(2)}`,
      );
    }
    for (const c of components) {
      if (REFERENCE_REQUIRED_METHODS.has(c.method) && !c.externalReference) {
        throw new BadRequestException(`${c.method} requires an external reference`);
      }
    }

    const primaryServiceItem = washOrder.items.find((i) => i.itemType === 'SERVICE' && i.service);
    const tier = primaryServiceItem?.service?.tier ?? 'standard';

    const paymentMethods = await this.prisma.paymentMethodConfig.findMany({
      where: { code: { in: components.map((c) => c.method) } },
    });
    const methodIdByCode = new Map(paymentMethods.map((m) => [m.code, m.id]));

    return this.prisma.$transaction(async (tx) => {
      const existingPayment = await tx.payment.findUnique({ where: { washOrderId } });
      if (existingPayment) {
        return tx.washOrder.findUniqueOrThrow({ where: { id: washOrderId }, include: { payment: { include: { components: true } } } });
      }

      const payment = await tx.payment.create({
        data: {
          washOrderId,
          createdById: actor.userId,
          deviceId: actor.deviceId,
          totalAmount: washOrder.totalAmount,
          status: 'COMPLETED',
          completedAt: new Date(),
        },
      });

      for (const c of components) {
        let walletLedgerId: string | undefined;
        let packageUsageId: string | undefined;
        let loyaltyRewardId: string | undefined;

        if (c.method === 'WALLET') {
          const entry = await this.prepaid.debitForWash(tx, {
            customerId: washOrder.customerId,
            amount: c.amount,
            washOrderId,
            clientEntryId: `finish:${washOrderId}:wallet`,
            actorId: actor.userId,
            deviceId: actor.deviceId,
          });
          walletLedgerId = entry.id;
        } else if (c.method === 'PACKAGE') {
          const purchase = await this.prepaid.findApplicablePurchase(tx, washOrder.customerId, washOrder.vehicleId, tier);
          if (!purchase) throw new ConflictException(`No active package covers this service for this vehicle`);
          const usage = await this.prepaid.useForWash(tx, {
            purchaseId: purchase.id,
            washOrderId,
            vehicleId: washOrder.vehicleId,
            clientEntryId: `finish:${washOrderId}:package`,
            actorId: actor.userId,
          });
          packageUsageId = usage.id;
        } else if (c.method === 'LOYALTY_FREE_WASH') {
          const reward = await this.loyalty.findAvailableReward(tx, washOrder.vehicleId, new Date());
          if (!reward) throw new ConflictException('No free wash is available for this vehicle this month');
          await this.loyalty.redeemReward(tx, { rewardId: reward.id, washOrderId, actorId: actor.userId, deviceId: actor.deviceId });
          loyaltyRewardId = reward.id;
        }

        const methodId = methodIdByCode.get(c.method);
        if (!methodId) throw new BadRequestException(`Payment method ${c.method} is not configured`);

        await tx.paymentComponent.create({
          data: {
            paymentId: payment.id,
            paymentMethodId: methodId,
            amount: c.amount,
            externalReference: c.externalReference,
            walletLedgerId,
            packageUsageId,
            loyaltyRewardId,
          },
        });
      }

      const updatedWash = await tx.washOrder.update({
        where: { id: washOrderId },
        data: {
          status: 'COMPLETED',
          completedAt: new Date(),
          statusHistory: { create: { fromStatus: washOrder.status, toStatus: 'COMPLETED', changedById: actor.userId, deviceId: actor.deviceId } },
        },
      });

      const isFreeWashOnly = components.length === 1 && components[0].method === 'LOYALTY_FREE_WASH';
      const qualifies = Number(washOrder.totalAmount) > 0 && !isFreeWashOnly && components.some((c) => QUALIFYING_METHODS.has(c.method) && c.amount > 0);

      let loyaltyResult: { earned: boolean; count: number } = { earned: false, count: 0 };
      if (qualifies) {
        loyaltyResult = await this.loyalty.creditQualifyingWash(tx, {
          vehicleId: washOrder.vehicleId,
          washOrderId,
          at: new Date(),
          actorId: actor.userId,
          deviceId: actor.deviceId,
        });
      }

      const vehicle = await tx.vehicle.findUniqueOrThrow({ where: { id: washOrder.vehicleId } });
      const customer = await tx.customer.findUniqueOrThrow({ where: { id: washOrder.customerId } });
      const redeemed = isFreeWashOnly;
      const remaining = Math.max(0, 5 - loyaltyResult.count);

      const body = redeemed
        ? `De Nest Car Wash: Your car ${vehicle.regNumberDisplay} is ready for collection. Your free monthly wash was used today. Thank you.`
        : loyaltyResult.earned
          ? `De Nest Car Wash: Your car ${vehicle.regNumberDisplay} is ready for collection. Congratulations! This car has earned a free wash for completing 5 paid washes this month.`
          : qualifies && remaining > 0
            ? `De Nest Car Wash: Your car ${vehicle.regNumberDisplay} has finished being washed and is ready for collection. You need ${remaining} more paid wash${remaining === 1 ? '' : 'es'} this month to earn a free wash. Thank you.`
            : `De Nest Car Wash: Your car ${vehicle.regNumberDisplay} has finished being washed and is ready for collection. Thank you.`;

      await this.sms.enqueue(tx, {
        messageKey: `wash:${washOrderId}:complete`,
        phone: customer.phone,
        templateCode: 'WASH_COMPLETE',
        body,
        customerId: customer.id,
        washOrderId,
      });

      await this.audit.record({
        branchId: actor.branchId,
        userId: actor.userId,
        deviceId: actor.deviceId,
        action: 'WASH_COMPLETED',
        entityType: 'WashOrder',
        entityId: washOrderId,
        afterSnapshot: { total: washOrder.totalAmount, methods: components.map((c) => c.method) },
      });

      return tx.washOrder.findUniqueOrThrow({
        where: { id: washOrderId },
        include: { payment: { include: { components: true } } },
      });
    });
  }

  /** Supervisor+ PIN-gated (enforced by the controller's PinOverrideGuard). */
  async voidPayment(washOrderId: string, reason: string, actor: AuthenticatedUser, approvedByUserId: string) {
    const washOrder = await this.prisma.washOrder.findUniqueOrThrow({
      where: { id: washOrderId },
      include: { payment: { include: { components: true } } },
    });
    if (!washOrder.payment || washOrder.payment.voided) {
      throw new BadRequestException('This wash has no active payment to void');
    }

    return this.prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { id: washOrder.payment!.id },
        data: { voided: true, voidedAt: new Date(), voidReason: reason, status: 'VOIDED' },
      });

      await tx.washOrder.update({
        where: { id: washOrderId },
        data: {
          status: 'CANCELLED',
          cancelledAt: new Date(),
          cancelReason: reason,
          statusHistory: { create: { fromStatus: washOrder.status, toStatus: 'CANCELLED', changedById: actor.userId, deviceId: actor.deviceId } },
        },
      });

      const loyaltyReversal = await this.loyalty.reverseWash(tx, { washOrderId, actorId: actor.userId, deviceId: actor.deviceId, reason });

      for (const component of washOrder.payment!.components) {
        if (component.walletLedgerId) {
          await this.prepaid.refundToWallet(tx, {
            customerId: washOrder.customerId,
            amount: Number(component.amount),
            reference: `Void refund: wash ${washOrderId}`,
            clientEntryId: `void:${washOrderId}:wallet`,
            actorId: actor.userId,
            deviceId: actor.deviceId,
          });
        }
        if (component.packageUsageId) {
          const usage = await tx.prepaidPackageUsage.findUniqueOrThrow({ where: { id: component.packageUsageId } });
          await this.prepaid.refundPackageUsage(tx, usage.purchaseId);
        }
      }

      await this.audit.record({
        branchId: actor.branchId,
        userId: actor.userId,
        deviceId: actor.deviceId,
        action: 'PAYMENT_VOIDED',
        entityType: 'WashOrder',
        entityId: washOrderId,
        afterSnapshot: { reason, approvedByUserId, loyaltyFlaggedForReview: loyaltyReversal.flaggedForReview },
      });

      return tx.washOrder.findUniqueOrThrow({ where: { id: washOrderId }, include: { payment: { include: { components: true } } } });
    });
  }
}
