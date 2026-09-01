import { RoleName } from '@prisma/client';

/** Roles are cumulative: each level includes everything the ones before it can do. */
export const ROLE_RANK: Record<RoleName, number> = {
  ATTENDANT: 0,
  SUPERVISOR: 1,
  ADMINISTRATOR: 2,
  OWNER: 3,
};

export function roleAtLeast(actual: RoleName, required: RoleName): boolean {
  return ROLE_RANK[actual] >= ROLE_RANK[required];
}

/** True if `actual` meets or exceeds the lowest of the acceptable roles. */
export function roleSatisfiesAny(actual: RoleName, acceptable: RoleName[]): boolean {
  if (acceptable.length === 0) return true;
  const minRequired = Math.min(...acceptable.map((r) => ROLE_RANK[r]));
  return ROLE_RANK[actual] >= minRequired;
}
