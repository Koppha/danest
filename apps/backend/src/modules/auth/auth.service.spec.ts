import { describe, it, expect, beforeEach, vi } from 'vitest';
import * as argon2 from 'argon2';
import { UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service.js';
import { AuditService } from '../audit/audit.service.js';

interface FakeUser {
  id: string;
  branchId: string;
  fullName: string;
  username: string;
  passwordHash: string;
  active: boolean;
  lastLoginAt: Date | null;
  role: { name: 'ATTENDANT' | 'SUPERVISOR' | 'ADMINISTRATOR' | 'OWNER' };
}

interface FakeRefreshToken {
  id: string;
  userId: string;
  tokenHash: string;
  expiresAt: Date;
  revokedAt: Date | null;
  replacedByTokenId: string | null;
}

/** Minimal in-memory stand-in for PrismaService, just enough surface for AuthService. */
function makeFakePrisma(users: FakeUser[]) {
  const usersById = new Map(users.map((u) => [u.id, u]));
  const usersByUsername = new Map(users.map((u) => [u.username, u]));
  const refreshTokens = new Map<string, FakeRefreshToken>();
  let seq = 0;

  return {
    user: {
      findUnique: vi.fn(async ({ where }: any) => {
        if (where.username) return usersByUsername.get(where.username) ?? null;
        if (where.id) return usersById.get(where.id) ?? null;
        return null;
      }),
      findUniqueOrThrow: vi.fn(async ({ where }: any) => {
        const u = usersById.get(where.id);
        if (!u) throw new Error('not found');
        return u;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const u = usersById.get(where.id)!;
        Object.assign(u, data);
        return u;
      }),
    },
    refreshToken: {
      create: vi.fn(async ({ data }: any) => {
        const id = `rt-${++seq}`;
        const record: FakeRefreshToken = { id, revokedAt: null, replacedByTokenId: null, ...data };
        refreshTokens.set(record.tokenHash, record);
        return record;
      }),
      findUnique: vi.fn(async ({ where, include }: any) => {
        const record = refreshTokens.get(where.tokenHash);
        if (!record) return null;
        if (include?.user) return { ...record, user: usersById.get(record.userId) };
        return record;
      }),
      update: vi.fn(async ({ where, data }: any) => {
        const record = [...refreshTokens.values()].find((r) => r.id === where.id)!;
        Object.assign(record, data);
        return record;
      }),
      updateMany: vi.fn(async ({ where, data }: any) => {
        let count = 0;
        for (const record of refreshTokens.values()) {
          if (record.userId === where.userId && record.tokenHash === where.tokenHash && record.revokedAt === null) {
            Object.assign(record, data);
            count++;
          }
        }
        return { count };
      }),
    },
    __refreshTokens: refreshTokens,
  };
}

async function buildService(users: FakeUser[]) {
  const prisma = makeFakePrisma(users);
  const jwt = new JwtService({});
  const config = new ConfigService({
    jwt: {
      accessSecret: 'test-access-secret',
      accessTtl: '15m',
      refreshSecret: 'test-refresh-secret',
      refreshTtl: '30d',
    },
  });
  const audit = { record: vi.fn(async () => undefined) } as unknown as AuditService;
  const service = new AuthService(prisma as any, jwt, config, audit);
  return { service, prisma, audit };
}

describe('AuthService', () => {
  let attendant: FakeUser;

  beforeEach(async () => {
    attendant = {
      id: 'user-1',
      branchId: 'branch-1',
      fullName: 'Tumelo',
      username: 'tumelo',
      passwordHash: await argon2.hash('correct-horse-battery'),
      active: true,
      lastLoginAt: null,
      role: { name: 'ATTENDANT' },
    };
  });

  it('logs in with correct credentials and issues an access + refresh token pair', async () => {
    const { service, audit } = await buildService([attendant]);
    const result = await service.login('tumelo', 'correct-horse-battery');

    expect(result.accessToken).toBeTruthy();
    expect(result.refreshToken).toBeTruthy();
    expect(result.user.username).toBe('tumelo');
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'LOGIN_SUCCESS' }));
  });

  it('rejects an incorrect password without revealing which field was wrong', async () => {
    const { service, audit } = await buildService([attendant]);
    await expect(service.login('tumelo', 'wrong-password')).rejects.toThrow(UnauthorizedException);
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'LOGIN_FAILED' }));
  });

  it('rejects login for a deactivated user', async () => {
    attendant.active = false;
    const { service } = await buildService([attendant]);
    await expect(service.login('tumelo', 'correct-horse-battery')).rejects.toThrow(UnauthorizedException);
  });

  it('rejects an unknown username', async () => {
    const { service } = await buildService([attendant]);
    await expect(service.login('nobody', 'whatever')).rejects.toThrow(UnauthorizedException);
  });

  it('rotates the refresh token: old token is revoked and points at the new one', async () => {
    const { service, prisma } = await buildService([attendant]);
    const first = await service.login('tumelo', 'correct-horse-battery');

    const second = await service.refresh(first.refreshToken);
    expect(second.refreshToken).not.toBe(first.refreshToken);

    const allTokens = [...prisma.__refreshTokens.values()];
    const oldRecord = allTokens.find((t: FakeRefreshToken) => t.id !== undefined && t.revokedAt !== null);
    expect(oldRecord).toBeTruthy();
    expect(oldRecord!.replacedByTokenId).toBeTruthy();
  });

  it('rejects reusing an already-rotated (revoked) refresh token', async () => {
    const { service } = await buildService([attendant]);
    const first = await service.login('tumelo', 'correct-horse-battery');
    await service.refresh(first.refreshToken); // rotates, revoking `first`

    await expect(service.refresh(first.refreshToken)).rejects.toThrow(UnauthorizedException);
  });

  it('rejects an unrecognized refresh token', async () => {
    const { service } = await buildService([attendant]);
    await expect(service.refresh('not-a-real-token')).rejects.toThrow(UnauthorizedException);
  });

  it('logout revokes the presented refresh token so it can no longer be used', async () => {
    const { service } = await buildService([attendant]);
    const first = await service.login('tumelo', 'correct-horse-battery');

    await service.logout(attendant.id, first.refreshToken);
    await expect(service.refresh(first.refreshToken)).rejects.toThrow(UnauthorizedException);
  });
});
