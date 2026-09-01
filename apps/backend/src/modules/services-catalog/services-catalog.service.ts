import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type {
  CreateWashServiceDto,
  UpdateWashServiceDto,
  CreateWashExtraDto,
  UpdateWashExtraDto,
} from './dto/service-extra.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class ServicesCatalogService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  listServices(activeOnly = true) {
    return this.prisma.washService.findMany({ where: activeOnly ? { active: true } : undefined, orderBy: { basePrice: 'asc' } });
  }

  listExtras(activeOnly = true) {
    return this.prisma.washExtra.findMany({ where: activeOnly ? { active: true } : undefined, orderBy: { price: 'asc' } });
  }

  async createService(dto: CreateWashServiceDto, actor: AuthenticatedUser) {
    const service = await this.prisma.washService.create({ data: dto });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'SERVICE_CREATED',
      entityType: 'WashService',
      entityId: service.id,
      afterSnapshot: service,
    });
    return service;
  }

  async updateService(id: string, dto: UpdateWashServiceDto, actor: AuthenticatedUser) {
    const before = await this.prisma.washService.findUniqueOrThrow({ where: { id } });
    const service = await this.prisma.washService.update({ where: { id }, data: dto });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'SERVICE_PRICE_CHANGED',
      entityType: 'WashService',
      entityId: id,
      beforeSnapshot: { basePrice: before.basePrice },
      afterSnapshot: { basePrice: service.basePrice },
    });
    return service;
  }

  async createExtra(dto: CreateWashExtraDto, actor: AuthenticatedUser) {
    const extra = await this.prisma.washExtra.create({ data: dto });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'EXTRA_CREATED',
      entityType: 'WashExtra',
      entityId: extra.id,
      afterSnapshot: extra,
    });
    return extra;
  }

  async updateExtra(id: string, dto: UpdateWashExtraDto, actor: AuthenticatedUser) {
    const before = await this.prisma.washExtra.findUniqueOrThrow({ where: { id } });
    const extra = await this.prisma.washExtra.update({ where: { id }, data: dto });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'EXTRA_PRICE_CHANGED',
      entityType: 'WashExtra',
      entityId: id,
      beforeSnapshot: { price: before.price },
      afterSnapshot: { price: extra.price },
    });
    return extra;
  }
}
