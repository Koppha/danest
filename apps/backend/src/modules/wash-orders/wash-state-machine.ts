import { WashStatus } from '@prisma/client';

/**
 * COMPLETED is deliberately unreachable here — it is only ever set by the
 * payments module's finish-wash orchestration (which also records payment,
 * loyalty and prepaid side effects atomically), never by a raw status
 * transition. READY -> WASHING is allowed so an attendant can step back
 * after a mis-tap without needing a supervisor override.
 */
const LEGAL_TRANSITIONS: Record<WashStatus, WashStatus[]> = {
  WAITING: ['WASHING', 'CANCELLED'],
  WASHING: ['READY', 'CANCELLED'],
  READY: ['WASHING', 'CANCELLED'],
  COMPLETED: [],
  CANCELLED: [],
};

export function isLegalTransition(from: WashStatus, to: WashStatus): boolean {
  return LEGAL_TRANSITIONS[from]?.includes(to) ?? false;
}
