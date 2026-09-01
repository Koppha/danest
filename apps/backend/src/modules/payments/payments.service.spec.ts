import { describe, it, expect, vi, beforeEach } from 'vitest';
import { BadRequestException } from '@nestjs/common';
import { PaymentsService } from './payments.service.js';

function makeFakePrisma(washOrder: any) {
  const state = { washOrder: { ...washOrder }, payment: null as any, paymentComponents: [] as any[] };

  const paymentMethodRows = [
    { code: 'CASH', id: 'pm-cash' },
    { code: 'CARD', id: 'pm-card' },
    { code: 'MOBILE_MONEY', id: 'pm-mm' },
    { code: 'BANK_TRANSFER', id: 'pm-bank' },
    { code: 'WALLET', id: 'pm-wallet' },
    { code: 'PACKAGE', id: 'pm-package' },
    { code: 'LOYALTY_FREE_WASH', id: 'pm-loyalty' },
  ];

  const tx = {
    payment: {
      findUnique: vi.fn(async () => state.payment),
      create: vi.fn(async ({ data }: any) => {
        state.payment = { id: 'payment-1', ...data };
        return state.payment;
      }),
    },
    paymentComponent: {
      create: vi.fn(async ({ data }: any) => {
        const row = { id: `pc-${state.paymentComponents.length + 1}`, ...data };
        state.paymentComponents.push(row);
        return row;
      }),
    },
    washOrder: {
      update: vi.fn(async ({ data }: any) => {
        Object.assign(state.washOrder, data);
        return state.washOrder;
      }),
      findUniqueOrThrow: vi.fn(async () => ({ ...state.washOrder, payment: { ...state.payment, components: state.paymentComponents } })),
    },
  };

  const prisma = {
    washOrder: {
      findUnique: vi.fn(async () => ({ ...state.washOrder, items: washOrder.items, payment: state.payment })),
      findUniqueOrThrow: tx.washOrder.findUniqueOrThrow,
    },
    paymentMethodConfig: {
      findMany: vi.fn(async ({ where }: any) => paymentMethodRows.filter((m) => where.code.in.includes(m.code))),
    },
    $transaction: vi.fn(async (cb: any) => cb(tx)),
  };

  return { prisma, tx, state };
}

function buildService(prisma: any) {
  const audit = { record: vi.fn(async () => undefined) } as any;
  const loyalty = {
    creditQualifyingWash: vi.fn(async () => ({ earned: false, count: 1 })),
    findAvailableReward: vi.fn(async () => ({ id: 'reward-1' })),
    redeemReward: vi.fn(async () => undefined),
  } as any;
  const prepaid = {
    debitForWash: vi.fn(async () => ({ id: 'wl-entry-1' })),
    findApplicablePurchase: vi.fn(),
    useForWash: vi.fn(),
  } as any;
  return { service: new PaymentsService(prisma, audit, loyalty, prepaid), loyalty, prepaid };
}

const baseWashOrder = {
  id: 'wash-1',
  status: 'READY',
  totalAmount: 100,
  vehicleId: 'veh-1',
  customerId: 'cust-1',
  items: [{ itemType: 'SERVICE', service: { tier: 'standard' } }],
};
const actor = { userId: 'user-1', branchId: 'branch-1', role: 'ATTENDANT', deviceId: 'device-1' } as any;

describe('PaymentsService.finishWash', () => {
  it('rejects when payment components do not sum to the wash total', async () => {
    const { prisma } = makeFakePrisma(baseWashOrder);
    const { service } = buildService(prisma);

    await expect(
      service.finishWash('wash-1', [{ method: 'CASH', amount: 60 }], actor),
    ).rejects.toThrow(BadRequestException);
  });

  it('rejects a mobile money component with no external reference', async () => {
    const { prisma } = makeFakePrisma(baseWashOrder);
    const { service } = buildService(prisma);

    await expect(
      service.finishWash('wash-1', [{ method: 'MOBILE_MONEY', amount: 100 }], actor),
    ).rejects.toThrow(BadRequestException);
  });

  it('accepts a valid split payment, completes the wash, and credits loyalty once', async () => {
    const { prisma, state } = makeFakePrisma(baseWashOrder);
    const { service, loyalty } = buildService(prisma);

    const result = await service.finishWash(
      'wash-1',
      [
        { method: 'CASH', amount: 60 },
        { method: 'MOBILE_MONEY', amount: 40, externalReference: 'QT1234' },
      ],
      actor,
    );

    expect(state.washOrder.status).toBe('COMPLETED');
    expect(state.paymentComponents.length).toBe(2);
    expect(loyalty.creditQualifyingWash).toHaveBeenCalledTimes(1);
    expect(result.payment.components.length).toBe(2);
  });

  it('does not credit loyalty when the wash is paid entirely with the free-wash reward', async () => {
    const { prisma } = makeFakePrisma(baseWashOrder);
    const { service, loyalty } = buildService(prisma);

    await service.finishWash('wash-1', [{ method: 'LOYALTY_FREE_WASH', amount: 100 }], actor);

    expect(loyalty.redeemReward).toHaveBeenCalledTimes(1);
    expect(loyalty.creditQualifyingWash).not.toHaveBeenCalled();
  });

  it('is idempotent: calling finishWash again on an already-COMPLETED wash does not re-run side effects', async () => {
    const { prisma, state } = makeFakePrisma(baseWashOrder);
    const { service, loyalty } = buildService(prisma);

    await service.finishWash('wash-1', [{ method: 'CASH', amount: 100 }], actor);
    expect(state.washOrder.status).toBe('COMPLETED');

    loyalty.creditQualifyingWash.mockClear();

    await service.finishWash('wash-1', [{ method: 'CASH', amount: 100 }], actor);
    expect(loyalty.creditQualifyingWash).not.toHaveBeenCalled();
  });
});
