import { describe, it, expect } from 'vitest';
import { roleAtLeast, roleSatisfiesAny } from './role-hierarchy.js';

describe('role-hierarchy', () => {
  it('roleAtLeast is true when the actual role outranks or equals the required one', () => {
    expect(roleAtLeast('OWNER', 'ADMINISTRATOR')).toBe(true);
    expect(roleAtLeast('ADMINISTRATOR', 'ADMINISTRATOR')).toBe(true);
    expect(roleAtLeast('SUPERVISOR', 'ADMINISTRATOR')).toBe(false);
    expect(roleAtLeast('ATTENDANT', 'SUPERVISOR')).toBe(false);
  });

  it('roleSatisfiesAny passes with no restriction when the list is empty', () => {
    expect(roleSatisfiesAny('ATTENDANT', [])).toBe(true);
  });

  it('roleSatisfiesAny treats a role list as "at least the lowest listed role"', () => {
    // @Roles('ADMINISTRATOR', 'OWNER') means administrator-or-above
    expect(roleSatisfiesAny('ADMINISTRATOR', ['ADMINISTRATOR', 'OWNER'])).toBe(true);
    expect(roleSatisfiesAny('OWNER', ['ADMINISTRATOR', 'OWNER'])).toBe(true);
    expect(roleSatisfiesAny('SUPERVISOR', ['ADMINISTRATOR', 'OWNER'])).toBe(false);
    expect(roleSatisfiesAny('ATTENDANT', ['ADMINISTRATOR', 'OWNER'])).toBe(false);
  });
});
