import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type { RegisterDeviceDto } from './dto/register-device.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class DevicesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  list(branchId?: string) {
    return this.prisma.device.findMany({ where: branchId ? { branchId } : undefined, orderBy: { createdAt: 'desc' } });
  }

  async register(dto: RegisterDeviceDto, actor: AuthenticatedUser) {
    const existing = await this.prisma.device.findUnique({ where: { installId: dto.installId } });
    if (existing) throw new ConflictException('Device already registered');

    const device = await this.prisma.device.create({
      data: { ...dto, registeredById: actor.userId },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'DEVICE_REGISTERED',
      entityType: 'Device',
      entityId: device.id,
      afterSnapshot: device,
    });

    return device;
  }

  async revoke(id: string, actor: AuthenticatedUser) {
    const device = await this.prisma.device.update({ where: { id }, data: { status: 'REVOKED' } });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'DEVICE_REVOKED',
      entityType: 'Device',
      entityId: id,
    });
    return device;
  }
}
