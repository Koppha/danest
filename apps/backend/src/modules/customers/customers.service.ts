import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { normalizePhone } from '../../common/normalize.js';
import type { CreateCustomerDto } from './dto/create-customer.dto.js';
import type { UpdateCustomerDto } from './dto/update-customer.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class CustomersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  /** Search by phone, name, or (via vehicles) registration number. */
  async search(branchId: string, query?: string) {
    if (!query?.trim()) {
      return this.prisma.customer.findMany({
        where: { branchId },
        include: { vehicles: true },
        orderBy: { fullName: 'asc' },
        take: 20,
      });
    }

    const normalizedPhone = normalizePhone(query);
    return this.prisma.customer.findMany({
      where: {
        branchId,
        OR: [
          { fullName: { contains: query, mode: 'insensitive' } },
          { phone: { contains: query } },
          { phone: { contains: normalizedPhone } },
          { vehicles: { some: { regNumberNormalized: { contains: query.toUpperCase().replace(/[^A-Z0-9]/g, '') } } } },
        ],
      },
      include: { vehicles: true },
      take: 20,
    });
  }

  async getById(id: string) {
    return this.prisma.customer.findUniqueOrThrow({
      where: { id },
      include: { vehicles: true, wallet: true, packagePurchases: { include: { package: true } } },
    });
  }

  async create(dto: CreateCustomerDto, actor: AuthenticatedUser) {
    const phone = normalizePhone(dto.phone);
    const existing = await this.prisma.customer.findUnique({
      where: { branchId_phone: { branchId: dto.branchId, phone } },
    });
    if (existing) throw new ConflictException('A customer with this phone number already exists');

    const customer = await this.prisma.customer.create({
      data: {
        id: dto.id,
        branchId: dto.branchId,
        fullName: dto.fullName,
        phone,
        altPhone: dto.altPhone,
        notes: dto.notes,
      },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'CUSTOMER_CREATED',
      entityType: 'Customer',
      entityId: customer.id,
      afterSnapshot: customer,
    });

    return customer;
  }

  async update(id: string, dto: UpdateCustomerDto, actor: AuthenticatedUser) {
    const before = await this.prisma.customer.findUniqueOrThrow({ where: { id } });
    const customer = await this.prisma.customer.update({
      where: { id },
      data: { ...dto, phone: dto.phone ? normalizePhone(dto.phone) : undefined },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'CUSTOMER_UPDATED',
      entityType: 'Customer',
      entityId: id,
      beforeSnapshot: before,
      afterSnapshot: customer,
    });

    return customer;
  }
}
