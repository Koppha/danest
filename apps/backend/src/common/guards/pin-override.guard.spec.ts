import { describe, it, expect, beforeEach, vi } from 'vitest';
import 'reflect-metadata';
import * as argon2 from 'argon2';
import { BadRequestException, ForbiddenException, UnauthorizedException, type ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PinOverrideGuard } from './pin-override.guard.js';
import { REQUIRES_PIN_KEY } from '../decorators/requires-pin.decorator.js';

function fakeContext(body: any, requiresPin = true): ExecutionContext {
  const handler = function protectedHandler() {};
  if (requiresPin) Reflect.defineMetadata(REQUIRES_PIN_KEY, true, handler);
  const request = { body, user: { userId: 'attendant-1' } };
  return {
    switchToHttp: () => ({ getRequest: () => request }),
    getHandler: () => handler,
    getClass: () => class Controller {},
  } as unknown as ExecutionContext;
}

describe('PinOverrideGuard', () => {
  let prisma: any;
  let supervisorPin: string;

  beforeEach(async () => {
    supervisorPin = '1234';
    prisma = {
      user: {
        findUnique: vi.fn(async ({ where }: any) => {
          if (where.username === 'karabo' || where.id === 'attendant-1') {
            return {
              id: where.username === 'karabo' ? 'sup-1' : 'attendant-1',
              username: where.username ?? 'attendant',
              active: true,
              pinHash: where.username === 'karabo' ? await argon2.hash(supervisorPin) : null,
              role: { name: where.username === 'karabo' ? 'SUPERVISOR' : 'ATTENDANT' },
            };
          }
          return null;
        }),
      },
    };
  });

  it('passes through untouched when the route does not require a PIN', async () => {
    const guard = new PinOverrideGuard(new Reflector(), prisma);
    const ctx = fakeContext({}, false);
    await expect(guard.canActivate(ctx)).resolves.toBe(true);
  });

  it('rejects when overridePin or overrideReason is missing', async () => {
    const guard = new PinOverrideGuard(new Reflector(), prisma);
    const ctx = fakeContext({ overridePin: '1234' }); // missing reason
    await expect(guard.canActivate(ctx)).rejects.toThrow(BadRequestException);
  });

  it('rejects when the approving user is an attendant (below supervisor)', async () => {
    const guard = new PinOverrideGuard(new Reflector(), prisma);
    // current user is the attendant themself, who has no PIN configured
    const ctx = fakeContext({ overridePin: '0000', overrideReason: 'test' });
    await expect(guard.canActivate(ctx)).rejects.toThrow(ForbiddenException);
  });

  it('rejects an incorrect PIN for a valid supervisor', async () => {
    const guard = new PinOverrideGuard(new Reflector(), prisma);
    const ctx = fakeContext({ overridePin: 'wrong', overrideReason: 'test', overrideUsername: 'karabo' });
    await expect(guard.canActivate(ctx)).rejects.toThrow(UnauthorizedException);
  });

  it('accepts a correct supervisor PIN and attaches the approval to the request', async () => {
    const guard = new PinOverrideGuard(new Reflector(), prisma);
    const handler = function h() {};
    Reflect.defineMetadata(REQUIRES_PIN_KEY, true, handler);
    const request = {
      body: { overridePin: supervisorPin, overrideReason: 'goodwill discount', overrideUsername: 'karabo' },
      user: { userId: 'attendant-1' },
    };
    const ctx = {
      switchToHttp: () => ({ getRequest: () => request }),
      getHandler: () => handler,
      getClass: () => class Controller {},
    } as unknown as ExecutionContext;

    await expect(guard.canActivate(ctx)).resolves.toBe(true);
    expect((request as any).pinApproval).toEqual({ approvedByUserId: 'sup-1', reason: 'goodwill discount' });
  });
});
