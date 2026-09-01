import { Injectable, type CallHandler, type ExecutionContext, type NestInterceptor } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { tap } from 'rxjs/operators';
import { AUDIT_ACTION_KEY } from '../decorators/audit.decorator.js';
import { AuditService } from '../../modules/audit/audit.service.js';
import type { AuthenticatedUser } from '../types/authenticated-user.js';

/**
 * Opt-in baseline audit logging for routes marked with @Audit('ACTION_CODE').
 * Captures actor/device/action/entity id from the request+response only —
 * routes needing rich before/after diffs call AuditService.record() directly
 * from the service layer instead (or in addition).
 */
@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(
    private readonly reflector: Reflector,
    private readonly auditService: AuditService,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler) {
    const action = this.reflector.getAllAndOverride<string | undefined>(AUDIT_ACTION_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!action) return next.handle();

    const request = context.switchToHttp().getRequest();
    const user: AuthenticatedUser | undefined = request.user;
    const entityId = request.params?.id;

    return next.handle().pipe(
      tap((response) => {
        void this.auditService.record({
          branchId: user?.branchId,
          userId: user?.userId,
          deviceId: user?.deviceId,
          action,
          entityType: context.getClass().name.replace('Controller', ''),
          entityId: entityId ?? response?.id,
          ipAddress: request.ip,
        });
      }),
    );
  }
}
