import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
  type CanActivate,
  type ExecutionContext,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import * as argon2 from 'argon2';
import { PrismaService } from '../../database/prisma.service.js';
import { REQUIRES_PIN_KEY } from '../decorators/requires-pin.decorator.js';
import { roleAtLeast } from '../role-hierarchy.js';
import type { AuthenticatedUser } from '../types/authenticated-user.js';

@Injectable()
export class PinOverrideGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiresPin = this.reflector.getAllAndOverride<boolean | undefined>(REQUIRES_PIN_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiresPin) return true;

    const request = context.switchToHttp().getRequest();
    const currentUser: AuthenticatedUser = request.user;
    const { overridePin, overrideReason, overrideUsername } = request.body ?? {};

    if (!overridePin || !overrideReason) {
      throw new BadRequestException('overridePin and overrideReason are required for this action');
    }

    const approver = overrideUsername
      ? await this.prisma.user.findUnique({ where: { username: overrideUsername }, include: { role: true } })
      : await this.prisma.user.findUnique({ where: { id: currentUser.userId }, include: { role: true } });

    if (!approver || !approver.active) throw new UnauthorizedException('Approving user not found');
    if (!roleAtLeast(approver.role.name, 'SUPERVISOR')) {
      throw new ForbiddenException('Only a supervisor or above can approve this action');
    }
    if (!approver.pinHash) throw new ForbiddenException('Approving user has no PIN configured');

    const pinValid = await argon2.verify(approver.pinHash, overridePin);
    if (!pinValid) throw new UnauthorizedException('Incorrect PIN');

    request.pinApproval = { approvedByUserId: approver.id, reason: overrideReason as string };
    return true;
  }
}
