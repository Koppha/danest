import { Injectable, Logger } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import type { SmsProvider, SendSmsResult } from '../sms-provider.interface.js';

/**
 * Dev/test-only provider: logs the message and "succeeds" immediately.
 * Swap for a real provider (Africa's Talking / Twilio / Clickatell) behind
 * the same SmsProvider interface once live credentials are available.
 */
@Injectable()
export class MockSmsProvider implements SmsProvider {
  private readonly logger = new Logger('MockSmsProvider');

  async send(to: string, body: string): Promise<SendSmsResult> {
    this.logger.log(`[MOCK SMS] to=${to} body="${body}"`);
    return { providerMessageId: `mock-${randomUUID()}` };
  }
}
