import { describe, it, expect } from 'vitest';
import { normalizeRegNumber, normalizePhone } from './normalize.js';

describe('normalizeRegNumber', () => {
  it('uppercases and strips spaces/punctuation so equivalent plates collide', () => {
    expect(normalizeRegNumber('abc 123')).toBe('ABC123');
    expect(normalizeRegNumber('ABC-123')).toBe('ABC123');
    expect(normalizeRegNumber('AbC123')).toBe(normalizeRegNumber('abc 123'));
  });
});

describe('normalizePhone', () => {
  it('adds the default country code to a local-format number', () => {
    expect(normalizePhone('58123456')).toBe('+26658123456');
    expect(normalizePhone('058123456')).toBe('+26658123456');
  });

  it('preserves an explicit international number', () => {
    expect(normalizePhone('+27821234567')).toBe('+27821234567');
    expect(normalizePhone('0027821234567')).toBe('+27821234567');
  });

  it('normalizes formatting noise (spaces) to the same result', () => {
    expect(normalizePhone('58 123 456')).toBe(normalizePhone('58123456'));
  });
});
