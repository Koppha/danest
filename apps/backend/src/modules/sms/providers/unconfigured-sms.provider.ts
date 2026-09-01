import { Injectable } from '@nestjs/common';
import type { SmsProvider, SendSmsResult } from '../sms-provider.interface.js';

/**
 * Placeholder for a real provider (Africa's Talking / Twilio / Clickatell)
 * selected via SMS_PROVIDER but not yet given credentials in .env. Wiring
 * a real provider here is a same-shape drop-in behind SmsProvider — no
 * other code needs to change.
 */
@Injectable()
export class UnconfiguredSmsProvider implements SmsProvider {
  constructor(private readonly providerName: string) {}

  async send(): Promise<SendSmsResult> {
    throw new Error(
      `SMS provider "${this.providerName}" is selected but has no credentials configured in .env — see .env.example`,
    );
  }
}
