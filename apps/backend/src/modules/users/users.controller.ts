import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UsersService } from './users.service.js';
import { CreateUserDto } from './dto/create-user.dto.js';
import { UpdateUserDto } from './dto/update-user.dto.js';
import { SetPasswordDto, SetPinDto } from './dto/set-credential.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  list(@Query('branchId') branchId?: string) {
    return this.usersService.list(branchId);
  }

  @Post()
  @Audit('USER_CREATE')
  create(@Body() dto: CreateUserDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.usersService.create(dto, actor);
  }

  @Patch(':id')
  @Audit('USER_UPDATE')
  update(@Param('id') id: string, @Body() dto: UpdateUserDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.usersService.update(id, dto, actor);
  }

  @Patch(':id/password')
  @Audit('USER_PASSWORD_RESET')
  setPassword(@Param('id') id: string, @Body() dto: SetPasswordDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.usersService.setPassword(id, dto.password, actor);
  }

  @Patch(':id/pin')
  @Audit('USER_PIN_SET')
  setPin(@Param('id') id: string, @Body() dto: SetPinDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.usersService.setPin(id, dto.pin, actor);
  }
}
