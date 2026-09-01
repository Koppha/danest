import { describe, it, expect } from 'vitest';
import { isLegalTransition } from './wash-state-machine.js';

describe('wash order state machine', () => {
  it('allows the forward happy path', () => {
    expect(isLegalTransition('WAITING', 'WASHING')).toBe(true);
    expect(isLegalTransition('WASHING', 'READY')).toBe(true);
  });

  it('allows stepping back from READY to WASHING for a mis-tap', () => {
    expect(isLegalTransition('READY', 'WASHING')).toBe(true);
  });

  it('allows cancelling from any active state', () => {
    expect(isLegalTransition('WAITING', 'CANCELLED')).toBe(true);
    expect(isLegalTransition('WASHING', 'CANCELLED')).toBe(true);
    expect(isLegalTransition('READY', 'CANCELLED')).toBe(true);
  });

  it('never allows a raw transition into COMPLETED (only the finish-wash flow can)', () => {
    expect(isLegalTransition('WAITING', 'COMPLETED')).toBe(false);
    expect(isLegalTransition('WASHING', 'COMPLETED')).toBe(false);
    expect(isLegalTransition('READY', 'COMPLETED')).toBe(false);
  });

  it('treats COMPLETED and CANCELLED as terminal', () => {
    expect(isLegalTransition('COMPLETED', 'WAITING')).toBe(false);
    expect(isLegalTransition('CANCELLED', 'WAITING')).toBe(false);
    expect(isLegalTransition('COMPLETED', 'CANCELLED')).toBe(false);
  });

  it('rejects skipping straight from WAITING to READY', () => {
    expect(isLegalTransition('WAITING', 'READY')).toBe(false);
  });
});
