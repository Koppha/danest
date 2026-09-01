import { Body, Controller, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { VehiclesService } from './vehicles.service.js';
import { CreateVehicleDto } from './dto/create-vehicle.dto.js';
import { UpdateVehicleDto } from './dto/update-vehicle.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('vehicles')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('vehicles')
export class VehiclesController {
  constructor(private readonly vehiclesService: VehiclesService) {}

  @Get('by-customer/:customerId')
  listForCustomer(@Param('customerId') customerId: string) {
    return this.vehiclesService.listForCustomer(customerId);
  }

  @Post()
  @Audit('VEHICLE_CREATE')
  create(@Body() dto: CreateVehicleDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.vehiclesService.create(dto, actor);
  }

  @Patch(':id')
  @Audit('VEHICLE_UPDATE')
  update(@Param('id') id: string, @Body() dto: UpdateVehicleDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.vehiclesService.update(id, dto, actor);
  }
}
