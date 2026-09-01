import { Module } from '@nestjs/common';
import { PrepaidController } from './prepaid.controller.js';
import { PrepaidService } from './prepaid.service.js';

@Module({
  controllers: [PrepaidController],
  providers: [PrepaidService],
  exports: [PrepaidService],
})
export class PrepaidModule {}
