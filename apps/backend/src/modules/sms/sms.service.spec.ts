import { describe, it, expect, vi } from 'vitest';
import { SmsService } from './sms.service.js';

function makeFakeTx() {
  const messages: any[] = [];
  const tx = {
    smsMessage: {
      findUnique: vi.fn(async ({ where }: any) => messages.find((m) => m.messageKey === where.messageKey) ?? null),
      create: vi.fn(async ({ data }: any) => {
        const row = { id: `sm-${messages.length + 1}`, attemptCount: 0, ...data };
        messages.push(row);
        return row;
      }),
    },
  };
  return { tx, messages };
}

describe('SmsService.enqueue', () => {
  it('is idempotent per messageKey: a duplicate wash-complete enqueue does not create a second row', async () => {
    const { tx, messages } = makeFakeTx();
    const provider = { send: vi.fn() };
    const config = { get: vi.fn(() => 'DeNest') } as any;
    const service = new SmsService({} as any, provider as any, config);

    const params = {
      messageKey: 'wash:wash-1:complete',
      phone: '+26658123456',
      templateCode: 'WASH_COMPLETE',
      body: 'Your car is ready',
    };
    const first = await service.enqueue(tx as any, params);
    const second = await service.enqueue(tx as any, params);

    expect(messages.length).toBe(1);
    expect(second.id).toBe(first.id);
  });
});
