import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import configuration from './config/configuration.js';
import { PrismaModule } from './database/prisma.module.js';
import { AuditModule } from './modules/audit/audit.module.js';
import { AuthModule } from './modules/auth/auth.module.js';
import { UsersModule } from './modules/users/users.module.js';
import { DevicesModule } from './modules/devices/devices.module.js';
import { CustomersModule } from './modules/customers/customers.module.js';
import { VehiclesModule } from './modules/vehicles/vehicles.module.js';
import { ServicesCatalogModule } from './modules/services-catalog/services-catalog.module.js';
import { WashOrdersModule } from './modules/wash-orders/wash-orders.module.js';
import { LoyaltyModule } from './modules/loyalty/loyalty.module.js';
import { PrepaidModule } from './modules/prepaid/prepaid.module.js';
import { SmsModule } from './modules/sms/sms.module.js';
import { PaymentsModule } from './modules/payments/payments.module.js';
import { CollectionsModule } from './modules/collections/collections.module.js';
import { ExpensesModule } from './modules/expenses/expenses.module.js';
import { ReportsModule } from './modules/reports/reports.module.js';
import { BackupsModule } from './modules/backups/backups.module.js';
import { AuditInterceptor } from './common/interceptors/audit.interceptor.js';
import { IdempotencyInterceptor } from './common/interceptors/idempotency.interceptor.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [configuration] }),
    ThrottlerModule.forRootAsync({
      imports: [],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        throttlers: [
          { ttl: config.get<number>('throttle.ttlMs')!, limit: config.get<number>('throttle.limit')! },
        ],
      }),
    }),
    PrismaModule,
    AuditModule,
    AuthModule,
    UsersModule,
    DevicesModule,
    CustomersModule,
    VehiclesModule,
    ServicesCatalogModule,
    WashOrdersModule,
    LoyaltyModule,
    PrepaidModule,
    SmsModule,
    PaymentsModule,
    CollectionsModule,
    ExpensesModule,
    ReportsModule,
    BackupsModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_INTERCEPTOR, useClass: AuditInterceptor },
    { provide: APP_INTERCEPTOR, useClass: IdempotencyInterceptor },
  ],
})
export class AppModule {}
