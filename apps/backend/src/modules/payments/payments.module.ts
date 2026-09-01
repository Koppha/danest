import { Module } from '@nestjs/common';
import { PaymentsController } from './payments.controller.js';
import { PaymentsService } from './payments.service.js';
import { LoyaltyModule } from '../loyalty/loyalty.module.js';
import { PrepaidModule } from '../prepaid/prepaid.module.js';

@Module({
  imports: [LoyaltyModule, PrepaidModule],
  controllers: [PaymentsController],
  providers: [PaymentsService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
