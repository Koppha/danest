import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../../database/prisma.service.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('audit')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('audit')
export class AuditController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  list(@CurrentUser() actor: AuthenticatedUser, @Query('take') take?: string) {
    return this.prisma.auditLog.findMany({
      where: { branchId: actor.branchId },
      include: { user: { select: { fullName: true, username: true } } },
      orderBy: { createdAt: 'desc' },
      take: take ? parseInt(take, 10) : 100,
    });
  }
}
