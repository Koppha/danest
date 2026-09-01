import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { randomBytes, createHash } from 'node:crypto';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import { durationToMs } from '../../common/duration.js';
import type { JwtAccessPayload } from '../../common/types/authenticated-user.js';

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    username: string;
    fullName: string;
    role: string;
    branchId: string;
  };
}

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly audit: AuditService,
  ) {}

  async login(username: string, password: string, deviceId?: string): Promise<TokenPair> {
    const user = await this.prisma.user.findUnique({
      where: { username },
      include: { role: true },
    });

    if (!user || !user.active) {
      await this.audit.record({ action: 'LOGIN_FAILED', entityType: 'User', afterSnapshot: { username } });
      throw new UnauthorizedException('Invalid username or password');
    }

    const passwordValid = await argon2.verify(user.passwordHash, password);
    if (!passwordValid) {
      await this.audit.record({
        branchId: user.branchId,
        userId: user.id,
        action: 'LOGIN_FAILED',
        entityType: 'User',
        entityId: user.id,
      });
      throw new UnauthorizedException('Invalid username or password');
    }

    await this.prisma.user.update({ where: { id: user.id }, data: { lastLoginAt: new Date() } });
    await this.audit.record({
      branchId: user.branchId,
      userId: user.id,
      deviceId,
      action: 'LOGIN_SUCCESS',
      entityType: 'User',
      entityId: user.id,
    });

    return this.issueTokenPair(user.id, user.username, user.role.name, user.branchId, deviceId);
  }

  async refresh(rawRefreshToken: string): Promise<TokenPair> {
    const tokenHash = this.hashToken(rawRefreshToken);
    const stored = await this.prisma.refreshToken.findUnique({
      where: { tokenHash },
      include: { user: { include: { role: true } } },
    });

    if (!stored || stored.revokedAt || stored.expiresAt < new Date()) {
      throw new UnauthorizedException('Refresh token is invalid or expired');
    }
    if (!stored.user.active) throw new UnauthorizedException('User is no longer active');

    // Rotation: revoke the presented token before issuing a new pair.
    const pair = await this.issueTokenPair(
      stored.user.id,
      stored.user.username,
      stored.user.role.name,
      stored.user.branchId,
    );
    const newHash = this.hashToken(pair.refreshToken);
    const newRecord = await this.prisma.refreshToken.findUnique({ where: { tokenHash: newHash } });
    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date(), replacedByTokenId: newRecord?.id },
    });

    return pair;
  }

  async logout(userId: string, rawRefreshToken: string): Promise<void> {
    const tokenHash = this.hashToken(rawRefreshToken);
    await this.prisma.refreshToken.updateMany({
      where: { userId, tokenHash, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  private async issueTokenPair(
    userId: string,
    username: string,
    role: JwtAccessPayload['role'],
    branchId: string,
    deviceId?: string,
  ): Promise<TokenPair> {
    const payload: JwtAccessPayload = { sub: userId, username, role, branchId, deviceId };
    const accessTtlSeconds = Math.floor(durationToMs(this.config.get<string>('jwt.accessTtl')!) / 1000);
    const accessToken = this.jwt.sign(payload, {
      secret: this.config.get<string>('jwt.accessSecret'),
      expiresIn: accessTtlSeconds,
    });

    const rawRefreshToken = randomBytes(48).toString('base64url');
    const refreshTtlMs = durationToMs(this.config.get<string>('jwt.refreshTtl')!);
    await this.prisma.refreshToken.create({
      data: {
        userId,
        tokenHash: this.hashToken(rawRefreshToken),
        expiresAt: new Date(Date.now() + refreshTtlMs),
      },
    });

    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });

    return {
      accessToken,
      refreshToken: rawRefreshToken,
      user: { id: user.id, username: user.username, fullName: user.fullName, role, branchId },
    };
  }

  private hashToken(raw: string): string {
    // Refresh tokens are high-entropy random opaque strings, not user
    // secrets, so a fast deterministic hash (for unique-lookup) is
    // appropriate here — unlike passwords/PINs, which use argon2 below.
    return createHash('sha256').update(raw).digest('hex');
  }
}
