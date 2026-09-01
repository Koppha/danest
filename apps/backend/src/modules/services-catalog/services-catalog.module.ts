import { Module } from '@nestjs/common';
import { ServicesCatalogController } from './services-catalog.controller.js';
import { ServicesCatalogService } from './services-catalog.service.js';

@Module({
  controllers: [ServicesCatalogController],
  providers: [ServicesCatalogService],
  exports: [ServicesCatalogService],
})
export class ServicesCatalogModule {}
