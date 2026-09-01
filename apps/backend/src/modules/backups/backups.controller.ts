import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { BackupsService } from './backups.service.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';

@ApiTags('backups')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('backups')
export class BackupsController {
  constructor(private readonly backupsService: BackupsService) {}

  @Roles('ADMINISTRATOR', 'OWNER')
  @Get()
  list() {
    return this.backupsService.list();
  }

  @Roles('ADMINISTRATOR', 'OWNER')
  @Post('run')
  @Audit('BACKUP_TRIGGERED')
  async trigger() {
    // Fire-and-forget from the caller's perspective — poll GET /backups for status.
    void this.backupsService.runBackup();
    return { message: 'Backup started' };
  }
}
