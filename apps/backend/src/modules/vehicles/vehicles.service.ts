import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { normalizeRegNumber } from '../../common/normalize.js';
import type { CreateVehicleDto } from './dto/create-vehicle.dto.js';
import type { UpdateVehicleDto } from './dto/update-vehicle.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class VehiclesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  listForCustomer(customerId: string) {
    return this.prisma.vehicle.findMany({ where: { customerId }, orderBy: { createdAt: 'asc' } });
  }

  async create(dto: CreateVehicleDto, actor: AuthenticatedUser) {
    const regNumberNormalized = normalizeRegNumber(dto.regNumber);
    const existing = await this.prisma.vehicle.findUnique({ where: { regNumberNormalized } });
    if (existing) throw new ConflictException('A vehicle with this registration number already exists');

    const vehicle = await this.prisma.vehicle.create({
      data: {
        id: dto.id,
        customerId: dto.customerId,
        regNumberNormalized,
        regNumberDisplay: dto.regNumber.toUpperCase(),
        make: dto.make,
        model: dto.model,
        colour: dto.colour,
        vehicleType: dto.vehicleType,
      },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'VEHICLE_CREATED',
      entityType: 'Vehicle',
      entityId: vehicle.id,
      afterSnapshot: vehicle,
    });

    return vehicle;
  }

  async update(id: string, dto: UpdateVehicleDto, actor: AuthenticatedUser) {
    const before = await this.prisma.vehicle.findUniqueOrThrow({ where: { id } });
    const vehicle = await this.prisma.vehicle.update({ where: { id }, data: dto });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'VEHICLE_UPDATED',
      entityType: 'Vehicle',
      entityId: id,
      beforeSnapshot: before,
      afterSnapshot: vehicle,
    });

    return vehicle;
  }
}
