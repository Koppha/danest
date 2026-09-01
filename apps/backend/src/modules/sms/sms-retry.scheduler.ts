import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { SmsService } from './sms.service.js';

@Injectable()
export class SmsRetryScheduler {
  private readonly logger = new Logger('SmsRetryScheduler');

  constructor(private readonly smsService: SmsService) {}

  @Cron(CronExpression.EVERY_MINUTE)
  async handleDueRetries() {
    const count = await this.smsService.processDueRetries();
    if (count > 0) this.logger.log(`Processed ${count} due SMS retr${count === 1 ? 'y' : 'ies'}`);
  }
}
