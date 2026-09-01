import { Body, Controller, Param, Post, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PaymentsService } from './payments.service.js';
import { FinishWashDto } from './dto/finish-wash.dto.js';
import { VoidPaymentDto } from './dto/void-payment.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { PinOverrideGuard } from '../../common/guards/pin-override.guard.js';
import { RequiresPin } from '../../common/decorators/requires-pin.decorator.js';
import { Idempotent } from '../../common/decorators/idempotent.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('payments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('wash-orders/:washOrderId')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Idempotent()
  @Post('finish')
  @Audit('WASH_FINISH')
  finish(@Param('washOrderId') washOrderId: string, @Body() dto: FinishWashDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.paymentsService.finishWash(washOrderId, dto.components, actor);
  }

  @UseGuards(PinOverrideGuard)
  @RequiresPin()
  @Post('void')
  @Audit('PAYMENT_VOID')
  void(
    @Param('washOrderId') washOrderId: string,
    @Body() dto: VoidPaymentDto,
    @CurrentUser() actor: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const approval = (req as any).pinApproval as { approvedByUserId: string; reason: string };
    return this.paymentsService.voidPayment(washOrderId, dto.reason, actor, approval.approvedByUserId);
  }
}
