import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { BackupsService } from './backups.service.js';

@Injectable()
export class BackupsRetentionScheduler {
  private readonly logger = new Logger('BackupsRetentionScheduler');

  constructor(private readonly backupsService: BackupsService) {}

  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async pruneExpired() {
    const pruned = await this.backupsService.pruneExpired();
    if (pruned > 0) this.logger.log(`Pruned ${pruned} expired local backup file(s)`);
  }
}
