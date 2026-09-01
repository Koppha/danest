import { Body, Controller, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { WashOrdersService } from './wash-orders.service.js';
import { CreateWashOrderDto } from './dto/create-wash-order.dto.js';
import { TransitionWashOrderDto } from './dto/transition-wash-order.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { PinOverrideGuard } from '../../common/guards/pin-override.guard.js';
import { RequiresPin } from '../../common/decorators/requires-pin.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('wash-orders')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('wash-orders')
export class WashOrdersController {
  constructor(private readonly washOrdersService: WashOrdersService) {}

  @Get('queue')
  queue(@CurrentUser() actor: AuthenticatedUser) {
    return this.washOrdersService.listQueue(actor.branchId);
  }

  @Get(':id')
  getById(@Param('id') id: string) {
    return this.washOrdersService.getById(id);
  }

  @Post()
  @Audit('WASH_CREATE')
  create(@Body() dto: CreateWashOrderDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.washOrdersService.create(dto, actor);
  }

  @Patch(':id/status')
  @Audit('WASH_STATUS_CHANGE')
  transition(@Param('id') id: string, @Body() dto: TransitionWashOrderDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.washOrdersService.transition(id, dto.toStatus as 'WASHING' | 'READY', actor);
  }

  @UseGuards(PinOverrideGuard)
  @RequiresPin()
  @Patch(':id/cancel')
  @Audit('WASH_CANCEL')
  cancel(
    @Param('id') id: string,
    @Body() dto: TransitionWashOrderDto,
    @CurrentUser() actor: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const approval = (req as any).pinApproval as { approvedByUserId: string; reason: string };
    return this.washOrdersService.cancel(id, dto.cancelReason ?? approval.reason, actor, approval.approvedByUserId);
  }
}
