import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DevicesService } from './devices.service.js';
import { RegisterDeviceDto } from './dto/register-device.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('devices')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('devices')
export class DevicesController {
  constructor(private readonly devicesService: DevicesService) {}

  @Get()
  list(@Query('branchId') branchId?: string) {
    return this.devicesService.list(branchId);
  }

  @Post()
  register(@Body() dto: RegisterDeviceDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.devicesService.register(dto, actor);
  }

  @Patch(':id/revoke')
  revoke(@Param('id') id: string, @CurrentUser() actor: AuthenticatedUser) {
    return this.devicesService.revoke(id, actor);
  }
}
