import { describe, it, expect, vi } from 'vitest';
import { WashOrdersService } from './wash-orders.service.js';

function makeFakePrisma(wash: any) {
  const state = { wash: { ...wash } };

  const tx = {
    washOrder: {
      update: vi.fn(async ({ data }: any) => {
        Object.assign(state.wash, data);
        return state.wash;
      }),
    },
  };

  const prisma = {
    washOrder: {
      findUniqueOrThrow: vi.fn(async () => ({ ...state.wash })),
    },
    $transaction: vi.fn(async (cb: any) => cb(tx)),
  };

  return { prisma, tx, state };
}

function buildService(prisma: any, loyaltySummary: any) {
  const audit = { record: vi.fn(async () => undefined) } as any;
  const loyalty = { summaryForVehicle: vi.fn(async () => loyaltySummary) } as any;
  const sms = { enqueue: vi.fn(async () => ({ id: 'sms-1' })) } as any;
  return { service: new WashOrdersService(prisma, audit, loyalty, sms), loyalty, sms, audit };
}

const baseWash = {
  id: 'wash-1',
  status: 'WASHING',
  vehicleId: 'veh-1',
  customerId: 'cust-1',
  vehicle: { id: 'veh-1', regNumberDisplay: 'ABC 123' },
  customer: { id: 'cust-1', phone: '+26658123456' },
};
const actor = { userId: 'user-1', branchId: 'branch-1', role: 'ATTENDANT', deviceId: 'device-1' } as any;

describe('WashOrdersService.transition', () => {
  it('sends exactly one SMS mentioning remaining washes when moved to READY', async () => {
    const { prisma } = makeFakePrisma(baseWash);
    const { service, sms } = buildService(prisma, { qualifyingCount: 3, remaining: 2, availableReward: null });

    await service.transition('wash-1', 'READY', actor);

    expect(sms.enqueue).toHaveBeenCalledTimes(1);
    const [, params] = sms.enqueue.mock.calls[0];
    expect(params.messageKey).toBe('wash:wash-1:ready');
    expect(params.body).toContain('ABC 123');
    expect(params.body).toContain('2 more paid washes');
  });

  it('mentions the available free wash instead of a remaining count when one is available', async () => {
    const { prisma } = makeFakePrisma(baseWash);
    const { service, sms } = buildService(prisma, { qualifyingCount: 5, remaining: 0, availableReward: { id: 'reward-1' } });

    await service.transition('wash-1', 'READY', actor);

    const [, params] = sms.enqueue.mock.calls[0];
    expect(params.body).toContain('free wash available');
  });

  it('does not send any SMS when moving to WASHING', async () => {
    const waitingWash = { ...baseWash, status: 'WAITING' };
    const { prisma } = makeFakePrisma(waitingWash);
    const { service, sms } = buildService(prisma, { qualifyingCount: 0, remaining: 5, availableReward: null });

    await service.transition('wash-1', 'WASHING', actor);

    expect(sms.enqueue).not.toHaveBeenCalled();
  });

  it('rejects an illegal transition', async () => {
    const readyWash = { ...baseWash, status: 'COMPLETED' };
    const { prisma } = makeFakePrisma(readyWash);
    const { service } = buildService(prisma, { qualifyingCount: 0, remaining: 5, availableReward: null });

    await expect(service.transition('wash-1', 'READY', actor)).rejects.toThrow();
  });
});
