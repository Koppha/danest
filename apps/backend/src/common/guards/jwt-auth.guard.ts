import { Injectable, UnauthorizedException, type CanActivate, type ExecutionContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import type { AuthenticatedUser, JwtAccessPayload } from '../types/authenticated-user.js';

/**
 * Verifies the Bearer access token directly via JwtService rather than
 * Passport's AuthGuard mixin — Passport's dynamic-module wiring (each
 * consuming module needing its own PassportModule import) doesn't play
 * well with a feature-module-per-domain layout, and a JWT bearer check is
 * simple enough not to need the extra machinery.
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader: string | undefined = request.headers?.authorization;
    const token = authHeader?.startsWith('Bearer ') ? authHeader.slice(7) : undefined;
    if (!token) throw new UnauthorizedException('Missing bearer token');

    try {
      const payload = await this.jwt.verifyAsync<JwtAccessPayload>(token, {
        secret: this.config.get<string>('jwt.accessSecret'),
      });
      const user: AuthenticatedUser = {
        userId: payload.sub,
        username: payload.username,
        role: payload.role,
        branchId: payload.branchId,
        deviceId: payload.deviceId,
      };
      request.user = user;
      return true;
    } catch {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }
}
