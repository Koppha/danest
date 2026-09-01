import { describe, it, expect } from 'vitest';
import { UnauthorizedException, type ExecutionContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { JwtAuthGuard } from './jwt-auth.guard.js';

function fakeContext(headers: Record<string, string>) {
  const request: any = { headers };
  return {
    switchToHttp: () => ({ getRequest: () => request }),
  } as unknown as ExecutionContext;
}

function buildGuard() {
  const jwt = new JwtService({});
  const config = new ConfigService({ jwt: { accessSecret: 'test-secret' } });
  return { guard: new JwtAuthGuard(jwt, config), jwt, config };
}

describe('JwtAuthGuard', () => {
  it('rejects a request with no Authorization header', async () => {
    const { guard } = buildGuard();
    await expect(guard.canActivate(fakeContext({}))).rejects.toThrow(UnauthorizedException);
  });

  it('rejects a malformed (non-Bearer) Authorization header', async () => {
    const { guard } = buildGuard();
    await expect(guard.canActivate(fakeContext({ authorization: 'Basic abc123' }))).rejects.toThrow(UnauthorizedException);
  });

  it('rejects a token signed with the wrong secret', async () => {
    const { guard, jwt } = buildGuard();
    const badToken = jwt.sign({ sub: 'u1', username: 'x', role: 'ATTENDANT', branchId: 'b1' }, { secret: 'wrong-secret' });
    await expect(guard.canActivate(fakeContext({ authorization: `Bearer ${badToken}` }))).rejects.toThrow(UnauthorizedException);
  });

  it('rejects an expired token', async () => {
    const { guard, jwt } = buildGuard();
    const expired = jwt.sign(
      { sub: 'u1', username: 'x', role: 'ATTENDANT', branchId: 'b1' },
      { secret: 'test-secret', expiresIn: -10 },
    );
    await expect(guard.canActivate(fakeContext({ authorization: `Bearer ${expired}` }))).rejects.toThrow(UnauthorizedException);
  });

  it('accepts a valid token and attaches the decoded user to the request', async () => {
    const { guard, jwt } = buildGuard();
    const token = jwt.sign(
      { sub: 'u1', username: 'tumelo', role: 'ATTENDANT', branchId: 'b1', deviceId: 'dev-1' },
      { secret: 'test-secret', expiresIn: 900 },
    );
    const request: any = { headers: { authorization: `Bearer ${token}` } };
    const ctx = { switchToHttp: () => ({ getRequest: () => request }) } as unknown as ExecutionContext;

    await expect(guard.canActivate(ctx)).resolves.toBe(true);
    expect(request.user).toEqual({ userId: 'u1', username: 'tumelo', role: 'ATTENDANT', branchId: 'b1', deviceId: 'dev-1' });
  });
});
