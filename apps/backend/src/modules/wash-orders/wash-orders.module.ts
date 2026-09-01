import { Module } from '@nestjs/common';
import { WashOrdersController } from './wash-orders.controller.js';
import { WashOrdersService } from './wash-orders.service.js';
import { LoyaltyModule } from '../loyalty/loyalty.module.js';
import { SmsModule } from '../sms/sms.module.js';

@Module({
  imports: [LoyaltyModule, SmsModule],
  controllers: [WashOrdersController],
  providers: [WashOrdersService],
  exports: [WashOrdersService],
})
export class WashOrdersModule {}
