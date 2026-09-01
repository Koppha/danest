import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { LoyaltyService } from './loyalty.service.js';
import { ManualLoyaltyAdjustmentDto } from './dto/manual-adjustment.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { RequiresPin } from '../../common/decorators/requires-pin.decorator.js';
import { PinOverrideGuard } from '../../common/guards/pin-override.guard.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('loyalty')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('loyalty')
export class LoyaltyController {
  constructor(private readonly loyaltyService: LoyaltyService) {}

  @Get('vehicles/:vehicleId/summary')
  summary(@Param('vehicleId') vehicleId: string) {
    return this.loyaltyService.summaryForVehicle(vehicleId);
  }

  @UseGuards(RolesGuard, PinOverrideGuard)
  @Roles('ADMINISTRATOR', 'OWNER')
  @RequiresPin()
  @Post('adjustments')
  @Audit('LOYALTY_MANUAL_ADJUSTMENT')
  manualAdjustment(@Body() dto: ManualLoyaltyAdjustmentDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.loyaltyService.manualAdjustment({
      vehicleId: dto.vehicleId,
      note: dto.note,
      actorId: actor.userId,
      deviceId: actor.deviceId,
      branchId: actor.branchId,
    });
  }
}
