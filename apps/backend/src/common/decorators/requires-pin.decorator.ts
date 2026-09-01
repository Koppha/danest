import { SetMetadata } from '@nestjs/common';

export const REQUIRES_PIN_KEY = 'requiresPin';

/**
 * Marks a route as requiring a supervisor+ PIN override with a reason.
 * The request body must include `overridePin` (required), `overrideReason`
 * (required) and optionally `overrideUsername` (defaults to the current
 * user, letting an attendant hand the device to a supervisor to approve
 * in place without logging out).
 */
export const RequiresPin = () => SetMetadata(REQUIRES_PIN_KEY, true);
