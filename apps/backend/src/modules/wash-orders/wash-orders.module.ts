import { Module } from '@nestjs/common';
import { WashOrdersController } from './wash-orders.controller.js';
import { WashOrdersService } from './wash-orders.service.js';

@Module({
  controllers: [WashOrdersController],
  providers: [WashOrdersService],
  exports: [WashOrdersService],
})
export class WashOrdersModule {}
