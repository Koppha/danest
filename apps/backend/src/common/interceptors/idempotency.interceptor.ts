import {
  BadRequestException,
  ConflictException,
  Injectable,
  type CallHandler,
  type ExecutionContext,
  type NestInterceptor,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { createHash } from 'node:crypto';
import { from, of, type Observable } from 'rxjs';
import { switchMap, tap, catchError } from 'rxjs/operators';
import { PrismaService } from '../../database/prisma.service.js';
import { IDEMPOTENT_KEY } from '../decorators/idempotent.decorator.js';

/**
 * Outer idempotency cache for financially-sensitive endpoints (chiefly
 * "Finish Wash & Send SMS"). A repeated call with the same Idempotency-Key
 * returns the first call's stored response verbatim rather than re-running
 * the handler — this is what makes double-taps and sync-replay retries both
 * instant and side-effect-free. Individual side-effect tables (payments,
 * loyalty_ledger, wallet/package ledgers, sms_messages) additionally carry
 * their own unique constraints as defense-in-depth in case this cache is
 * ever bypassed.
 */
@Injectable()
export class IdempotencyInterceptor implements NestInterceptor {
  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const isIdempotent = this.reflector.getAllAndOverride<boolean | undefined>(IDEMPOTENT_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!isIdempotent) return next.handle();

    const request = context.switchToHttp().getRequest();
    const key: string | undefined = request.headers['idempotency-key'];
    if (!key) throw new BadRequestException('Idempotency-Key header is required for this action');

    const endpoint = `${context.getClass().name}.${context.getHandler().name}`;
    const requestHash = createHash('sha256').update(JSON.stringify(request.body ?? {})).digest('hex');

    return from(this.prisma.idempotencyKey.findUnique({ where: { key } })).pipe(
      switchMap((existing) => {
        if (existing) {
          if (existing.status === 'COMPLETED') return of(existing.responseSnapshot);
          if (existing.status === 'IN_PROGRESS') {
            throw new ConflictException('A request with this idempotency key is already in progress');
          }
          // FAILED: fall through and retry, resetting to IN_PROGRESS below.
        }
        return from(
          this.prisma.idempotencyKey.upsert({
            where: { key },
            create: { key, endpoint, requestHash, status: 'IN_PROGRESS' },
            update: { status: 'IN_PROGRESS', requestHash },
          }),
        ).pipe(
          switchMap(() =>
            next.handle().pipe(
              tap((response) => {
                void this.prisma.idempotencyKey.update({
                  where: { key },
                  data: { status: 'COMPLETED', responseSnapshot: response as any, completedAt: new Date() },
                });
              }),
              catchError((err) => {
                void this.prisma.idempotencyKey.update({ where: { key }, data: { status: 'FAILED' } });
                throw err;
              }),
            ),
          ),
        );
      }),
    );
  }
}
