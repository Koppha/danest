import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../database/prisma.service.js';
import { SMS_PROVIDER, type SmsProvider } from './sms-provider.interface.js';

type Tx = Prisma.TransactionClient;

const MAX_ATTEMPTS = 5;

export interface QueueMessageParams {
  messageKey: string;
  phone: string;
  templateCode: string;
  body: string;
  customerId?: string;
  washOrderId?: string;
}

@Injectable()
export class SmsService {
  private readonly logger = new Logger('SmsService');

  constructor(
    private readonly prisma: PrismaService,
    @Inject(SMS_PROVIDER) private readonly provider: SmsProvider,
    private readonly config: ConfigService,
  ) {}

  /**
   * Idempotent per messageKey (e.g. "wash:{id}:complete") — a duplicate
   * enqueue (double-tap, sync replay) is a no-op that returns the existing
   * row rather than sending a second SMS.
   */
  async enqueue(tx: Tx, params: QueueMessageParams) {
    const existing = await tx.smsMessage.findUnique({ where: { messageKey: params.messageKey } });
    if (existing) return existing;

    return tx.smsMessage.create({
      data: {
        messageKey: params.messageKey,
        customerId: params.customerId,
        washOrderId: params.washOrderId,
        phone: params.phone,
        templateCode: params.templateCode,
        renderedBody: params.body,
        status: 'QUEUED',
      },
    });
  }

  /** Attempts delivery for one message; exponential backoff on failure. */
  async attemptSend(messageId: string) {
    const message = await this.prisma.smsMessage.findUniqueOrThrow({ where: { id: messageId } });
    if (message.status === 'SENT' || message.status === 'DELIVERED') return message;

    try {
      const from = this.config.get<string>('sms.from')!;
      const result = await this.provider.send(message.phone, message.renderedBody, from);
      return this.prisma.smsMessage.update({
        where: { id: messageId },
        data: { status: 'SENT', providerMessageId: result.providerMessageId, attemptCount: { increment: 1 } },
      });
    } catch (err) {
      const attemptCount = message.attemptCount + 1;
      const failed = attemptCount >= MAX_ATTEMPTS;
      const backoffMs = Math.min(2 ** attemptCount * 60_000, 3_600_000); // cap at 1h
      this.logger.warn(`SMS send failed for ${messageId} (attempt ${attemptCount}): ${(err as Error).message}`);
      return this.prisma.smsMessage.update({
        where: { id: messageId },
        data: {
          status: failed ? 'FAILED' : 'QUEUED',
          attemptCount,
          lastError: (err as Error).message,
          nextAttemptAt: failed ? null : new Date(Date.now() + backoffMs),
        },
      });
    }
  }

  /** Called by a scheduled job (see SmsRetryScheduler) to drain due retries. */
  async processDueRetries() {
    const due = await this.prisma.smsMessage.findMany({
      where: {
        status: 'QUEUED',
        OR: [{ nextAttemptAt: null }, { nextAttemptAt: { lte: new Date() } }],
      },
      take: 50,
    });
    for (const message of due) {
      await this.attemptSend(message.id);
    }
    return due.length;
  }

  listRecent(limit = 100) {
    return this.prisma.smsMessage.findMany({ orderBy: { createdAt: 'desc' }, take: limit });
  }
}
