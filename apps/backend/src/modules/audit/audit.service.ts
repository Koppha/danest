import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';

export interface RecordAuditInput {
  branchId?: string;
  userId?: string;
  deviceId?: string;
  action: string;
  entityType: string;
  entityId?: string;
  beforeSnapshot?: unknown;
  afterSnapshot?: unknown;
  ipAddress?: string;
}

@Injectable()
export class AuditService {
  constructor(private readonly prisma: PrismaService) {}

  /** Append-only: audit_logs rows are never updated or deleted. */
  async record(input: RecordAuditInput) {
    await this.prisma.auditLog.create({
      data: {
        branchId: input.branchId,
        userId: input.userId,
        deviceId: input.deviceId,
        action: input.action,
        entityType: input.entityType,
        entityId: input.entityId,
        beforeSnapshot: input.beforeSnapshot as any,
        afterSnapshot: input.afterSnapshot as any,
        ipAddress: input.ipAddress,
      },
    });
  }
}
