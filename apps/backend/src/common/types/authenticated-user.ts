import type { RoleName } from '@prisma/client';

export interface AuthenticatedUser {
  userId: string;
  username: string;
  role: RoleName;
  branchId: string;
  deviceId?: string;
}

export interface JwtAccessPayload {
  sub: string;
  username: string;
  role: RoleName;
  branchId: string;
  deviceId?: string;
}
