import { describe, it, expect, vi } from 'vitest';
import { ConflictException } from '@nestjs/common';
import { UsersService } from './users.service.js';

function makeFakePrisma() {
  const users: any[] = [];
  const roles = [{ id: 'role-attendant', name: 'ATTENDANT' }];
  const prisma = {
    user: {
      findUnique: vi.fn(async ({ where }: any) => {
        if (where.id) return users.find((u) => u.id === where.id) ?? null;
        if (where.username) return users.find((u) => u.username === where.username) ?? null;
        return null;
      }),
      create: vi.fn(async ({ data }: any) => {
        const row = { id: data.id ?? `user-${users.length + 1}`, ...data };
        users.push(row);
        return row;
      }),
    },
    role: {
      findUnique: vi.fn(async ({ where }: any) => roles.find((r) => r.name === where.name) ?? null),
    },
  } as any;
  return { prisma, users };
}

const actor = { userId: 'admin-1', branchId: 'branch-1', deviceId: 'd' } as any;
const baseDto = { branchId: 'branch-1', fullName: 'Thabo Attendant', username: 'thabo', password: 'longenoughpw', role: 'ATTENDANT' } as any;

describe('UsersService.create', () => {
  it('is idempotent on a client-supplied id — a retried offline create does not throw "username already exists"', async () => {
    const { prisma, users } = makeFakePrisma();
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new UsersService(prisma, audit);
    const dto = { ...baseDto, id: 'client-uuid-1' };

    const first = await service.create(dto, actor);
    const second = await service.create(dto, actor);

    expect(second.id).toBe(first.id);
    expect(users).toHaveLength(1);
  });

  it('still rejects a genuine username collision from a different id', async () => {
    const { prisma } = makeFakePrisma();
    const audit = { record: vi.fn(async () => undefined) } as any;
    const service = new UsersService(prisma, audit);

    await service.create({ ...baseDto, id: 'client-uuid-1' }, actor);

    await expect(service.create({ ...baseDto, id: 'client-uuid-2' }, actor)).rejects.toThrow(ConflictException);
  });
});
