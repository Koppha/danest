import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CollectionsService } from './collections.service.js';
import { ConfirmCollectionDto } from './dto/confirm-collection.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('collections')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('collections')
export class CollectionsController {
  constructor(private readonly collectionsService: CollectionsService) {}

  @Get('pending')
  pending(@CurrentUser() actor: AuthenticatedUser) {
    return this.collectionsService.computeExpected(actor.branchId);
  }

  @Get()
  list(@CurrentUser() actor: AuthenticatedUser) {
    return this.collectionsService.list(actor.branchId);
  }

  @Post()
  @Audit('CASH_COLLECTION_CONFIRM')
  confirm(@Body() dto: ConfirmCollectionDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.collectionsService.confirm({ branchId: actor.branchId, ...dto, actor });
  }
}
