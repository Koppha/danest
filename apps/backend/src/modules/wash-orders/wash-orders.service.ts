import { BadRequestException, Injectable } from '@nestjs/common';
import { WashStatus } from '@prisma/client';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { LoyaltyService } from '../loyalty/loyalty.service.js';
import { SmsService } from '../sms/sms.service.js';
import { isLegalTransition } from './wash-state-machine.js';
import type { CreateWashOrderDto } from './dto/create-wash-order.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class WashOrdersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly loyalty: LoyaltyService,
    private readonly sms: SmsService,
  ) {}

  listQueue(branchId: string) {
    return this.prisma.washOrder.findMany({
      where: { branchId, status: { in: ['WAITING', 'WASHING', 'READY'] } },
      include: { vehicle: true, customer: true, items: true },
      orderBy: { createdAt: 'asc' },
    });
  }

  getById(id: string) {
    return this.prisma.washOrder.findUniqueOrThrow({
      where: { id },
      include: { vehicle: true, customer: true, items: true, statusHistory: true, payment: { include: { components: true } } },
    });
  }

  /** Idempotent on `dto.id` (client UUID) so offline retries never duplicate a wash order. */
  async create(dto: CreateWashOrderDto, actor: AuthenticatedUser) {
    const existing = await this.prisma.washOrder.findUnique({ where: { id: dto.id }, include: { items: true } });
    if (existing) return existing;

    const vehicle = await this.prisma.vehicle.findUniqueOrThrow({ where: { id: dto.vehicleId } });

    const serviceIds = dto.items.filter((i) => i.itemType === 'SERVICE' && i.serviceId).map((i) => i.serviceId!);
    const extraIds = dto.items.filter((i) => i.itemType === 'EXTRA' && i.extraId).map((i) => i.extraId!);
    const [services, extras] = await Promise.all([
      this.prisma.washService.findMany({ where: { id: { in: serviceIds } } }),
      this.prisma.washExtra.findMany({ where: { id: { in: extraIds } } }),
    ]);
    const serviceById = new Map(services.map((s) => [s.id, s]));
    const extraById = new Map(extras.map((e) => [e.id, e]));

    let total = 0;
    const itemsData = dto.items.map((item) => {
      const qty = item.qty ?? 1;
      if (item.itemType === 'SERVICE') {
        const svc = serviceById.get(item.serviceId!);
        if (!svc) throw new BadRequestException(`Unknown or inactive service ${item.serviceId}`);
        total += Number(svc.basePrice) * qty;
        return { itemType: 'SERVICE' as const, serviceId: svc.id, nameSnapshot: svc.name, priceSnapshot: svc.basePrice, qty };
      }
      const extra = extraById.get(item.extraId!);
      if (!extra) throw new BadRequestException(`Unknown or inactive extra ${item.extraId}`);
      total += Number(extra.price) * qty;
      return { itemType: 'EXTRA' as const, extraId: extra.id, nameSnapshot: extra.name, priceSnapshot: extra.price, qty };
    });

    const washOrder = await this.prisma.washOrder.create({
      data: {
        id: dto.id,
        branchId: actor.branchId,
        vehicleId: dto.vehicleId,
        customerId: vehicle.customerId,
        createdById: actor.userId,
        deviceId: dto.deviceId ?? actor.deviceId,
        totalAmount: total,
        status: 'WAITING',
        items: { create: itemsData },
        statusHistory: { create: { toStatus: 'WAITING', changedById: actor.userId, deviceId: dto.deviceId ?? actor.deviceId } },
      },
      include: { items: true },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'WASH_CREATED',
      entityType: 'WashOrder',
      entityId: washOrder.id,
      afterSnapshot: { vehicleId: dto.vehicleId, total },
    });

    return washOrder;
  }

  /** Non-terminal transitions only (WAITING<->WASHING<->READY); cancel() handles CANCELLED separately. */
  async transition(id: string, toStatus: Extract<WashStatus, 'WASHING' | 'READY'>, actor: AuthenticatedUser) {
    const wash = await this.prisma.washOrder.findUniqueOrThrow({ where: { id }, include: { vehicle: true, customer: true } });
    if (!isLegalTransition(wash.status, toStatus)) {
      throw new BadRequestException(`Cannot move a wash from ${wash.status} to ${toStatus}`);
    }

    const updated = await this.prisma.$transaction(async (tx) => {
      const result = await tx.washOrder.update({
        where: { id },
        data: {
          status: toStatus,
          statusHistory: { create: { fromStatus: wash.status, toStatus, changedById: actor.userId, deviceId: actor.deviceId } },
        },
      });

      if (toStatus === 'READY') {
        const loyaltySummary = await this.loyalty.summaryForVehicle(wash.vehicleId);
        const body = loyaltySummary.availableReward
          ? `De Nest Car Wash: Your car ${wash.vehicle.regNumberDisplay} is ready for collection. You have a free wash available on your next visit!`
          : loyaltySummary.remaining > 0
            ? `De Nest Car Wash: Your car ${wash.vehicle.regNumberDisplay} is ready for collection. You need ${loyaltySummary.remaining} more paid wash${loyaltySummary.remaining === 1 ? '' : 'es'} this month to earn a free wash. Thank you.`
            : `De Nest Car Wash: Your car ${wash.vehicle.regNumberDisplay} is ready for collection. Thank you.`;

        await this.sms.enqueue(tx, {
          messageKey: `wash:${id}:ready`,
          phone: wash.customer.phone,
          templateCode: 'WASH_READY',
          body,
          customerId: wash.customerId,
          washOrderId: id,
        });
      }

      return result;
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'WASH_STATUS_CHANGED',
      entityType: 'WashOrder',
      entityId: id,
      beforeSnapshot: { status: wash.status },
      afterSnapshot: { status: toStatus },
    });

    return updated;
  }

  /** Supervisor+ PIN-gated; the controller enforces the PIN via PinOverrideGuard before this runs. */
  async cancel(id: string, reason: string, actor: AuthenticatedUser, approvedByUserId: string) {
    const wash = await this.prisma.washOrder.findUniqueOrThrow({ where: { id } });
    if (!isLegalTransition(wash.status, 'CANCELLED')) {
      throw new BadRequestException(`Cannot cancel a wash that is already ${wash.status}`);
    }

    const updated = await this.prisma.washOrder.update({
      where: { id },
      data: {
        status: 'CANCELLED',
        cancelledAt: new Date(),
        cancelReason: reason,
        statusHistory: { create: { fromStatus: wash.status, toStatus: 'CANCELLED', changedById: actor.userId, deviceId: actor.deviceId } },
      },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'WASH_CANCELLED',
      entityType: 'WashOrder',
      entityId: id,
      beforeSnapshot: { status: wash.status },
      afterSnapshot: { status: 'CANCELLED', reason, approvedByUserId },
    });

    return updated;
  }
}
