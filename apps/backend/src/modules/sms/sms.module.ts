import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { SmsController } from './sms.controller.js';
import { SmsService } from './sms.service.js';
import { SmsRetryScheduler } from './sms-retry.scheduler.js';
import { SMS_PROVIDER } from './sms-provider.interface.js';
import { MockSmsProvider } from './providers/mock-sms.provider.js';
import { UnconfiguredSmsProvider } from './providers/unconfigured-sms.provider.js';

@Module({
  imports: [ConfigModule, ScheduleModule.forRoot()],
  controllers: [SmsController],
  providers: [
    SmsService,
    SmsRetryScheduler,
    {
      provide: SMS_PROVIDER,
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const providerName = config.get<string>('sms.provider');
        if (providerName === 'mock' || !providerName) return new MockSmsProvider();
        // africastalking | twilio | clickatell: credentials not wired yet — see .env.example.
        return new UnconfiguredSmsProvider(providerName);
      },
    },
  ],
  exports: [SmsService],
})
export class SmsModule {}
