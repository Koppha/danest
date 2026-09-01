import { Body, Controller, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ServicesCatalogService } from './services-catalog.service.js';
import {
  CreateWashServiceDto,
  UpdateWashServiceDto,
  CreateWashExtraDto,
  UpdateWashExtraDto,
} from './dto/service-extra.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('services-catalog')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller()
export class ServicesCatalogController {
  constructor(private readonly catalog: ServicesCatalogService) {}

  @Get('wash-services')
  listServices() {
    return this.catalog.listServices();
  }

  @Get('wash-extras')
  listExtras() {
    return this.catalog.listExtras();
  }

  @UseGuards(RolesGuard)
  @Roles('ADMINISTRATOR', 'OWNER')
  @Post('wash-services')
  @Audit('SERVICE_CREATE')
  createService(@Body() dto: CreateWashServiceDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.catalog.createService(dto, actor);
  }

  @UseGuards(RolesGuard)
  @Roles('ADMINISTRATOR', 'OWNER')
  @Patch('wash-services/:id')
  @Audit('SERVICE_UPDATE')
  updateService(@Param('id') id: string, @Body() dto: UpdateWashServiceDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.catalog.updateService(id, dto, actor);
  }

  @UseGuards(RolesGuard)
  @Roles('ADMINISTRATOR', 'OWNER')
  @Post('wash-extras')
  @Audit('EXTRA_CREATE')
  createExtra(@Body() dto: CreateWashExtraDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.catalog.createExtra(dto, actor);
  }

  @UseGuards(RolesGuard)
  @Roles('ADMINISTRATOR', 'OWNER')
  @Patch('wash-extras/:id')
  @Audit('EXTRA_UPDATE')
  updateExtra(@Param('id') id: string, @Body() dto: UpdateWashExtraDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.catalog.updateExtra(id, dto, actor);
  }
}
