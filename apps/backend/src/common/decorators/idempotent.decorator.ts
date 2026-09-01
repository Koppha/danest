import { SetMetadata } from '@nestjs/common';

export const IDEMPOTENT_KEY = 'idempotent';

/**
 * Marks a route as requiring an `Idempotency-Key` header. A repeated call
 * with the same key returns the cached response instead of re-running the
 * handler — see IdempotencyInterceptor.
 */
export const Idempotent = () => SetMetadata(IDEMPOTENT_KEY, true);
