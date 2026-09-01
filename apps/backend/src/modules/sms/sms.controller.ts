import { Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { SmsService } from './sms.service.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';

@ApiTags('sms')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('sms')
export class SmsController {
  constructor(private readonly smsService: SmsService) {}

  @Get()
  list() {
    return this.smsService.listRecent();
  }

  @Post(':id/resend')
  resend(@Param('id') id: string) {
    return this.smsService.attemptSend(id);
  }
}
