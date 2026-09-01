import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import * as argon2 from 'argon2';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type { CreateUserDto } from './dto/create-user.dto.js';
import type { UpdateUserDto } from './dto/update-user.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

const SAFE_SELECT = {
  id: true,
  branchId: true,
  fullName: true,
  username: true,
  active: true,
  lastLoginAt: true,
  createdAt: true,
  role: { select: { name: true } },
} as const;

@Injectable()
export class UsersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async list(branchId?: string) {
    return this.prisma.user.findMany({
      where: branchId ? { branchId } : undefined,
      select: SAFE_SELECT,
      orderBy: { fullName: 'asc' },
    });
  }

  /**
   * Idempotent on dto.id (client UUID) so an offline-queued retry never
   * throws "username already exists" against its own earlier success. A
   * genuine username collision (a different id) still rejects — that's a
   * real cross-device conflict, not a retry.
   */
  async create(dto: CreateUserDto, actor: AuthenticatedUser) {
    if (dto.id) {
      const byId = await this.prisma.user.findUnique({ where: { id: dto.id }, select: SAFE_SELECT });
      if (byId) return byId;
    }

    const existing = await this.prisma.user.findUnique({ where: { username: dto.username } });
    if (existing) throw new ConflictException('Username already exists');

    const role = await this.prisma.role.findUnique({ where: { name: dto.role } });
    if (!role) throw new NotFoundException('Role not found');

    const user = await this.prisma.user.create({
      data: {
        id: dto.id,
        branchId: dto.branchId,
        fullName: dto.fullName,
        username: dto.username,
        passwordHash: await argon2.hash(dto.password),
        pinHash: dto.pin ? await argon2.hash(dto.pin) : null,
        roleId: role.id,
      },
      select: SAFE_SELECT,
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'USER_CREATED',
      entityType: 'User',
      entityId: user.id,
      afterSnapshot: { username: user.username, role: dto.role },
    });

    return user;
  }

  async update(id: string, dto: UpdateUserDto, actor: AuthenticatedUser) {
    const before = await this.prisma.user.findUniqueOrThrow({ where: { id }, select: SAFE_SELECT });

    const roleId = dto.role
      ? (await this.prisma.role.findUniqueOrThrow({ where: { name: dto.role } })).id
      : undefined;

    const user = await this.prisma.user.update({
      where: { id },
      data: { fullName: dto.fullName, active: dto.active, roleId },
      select: SAFE_SELECT,
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'USER_UPDATED',
      entityType: 'User',
      entityId: id,
      beforeSnapshot: before,
      afterSnapshot: user,
    });

    return user;
  }

  async setPassword(id: string, password: string, actor: AuthenticatedUser) {
    await this.prisma.user.update({ where: { id }, data: { passwordHash: await argon2.hash(password) } });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'USER_PASSWORD_RESET',
      entityType: 'User',
      entityId: id,
    });
  }

  async setPin(id: string, pin: string, actor: AuthenticatedUser) {
    await this.prisma.user.update({ where: { id }, data: { pinHash: await argon2.hash(pin) } });
    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      action: 'USER_PIN_SET',
      entityType: 'User',
      entityId: id,
    });
  }
}
