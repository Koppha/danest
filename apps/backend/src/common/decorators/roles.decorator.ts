import { SetMetadata } from '@nestjs/common';
import type { RoleName } from '@prisma/client';

export const ROLES_KEY = 'roles';

/** Marks a route as requiring one of the given roles (or higher, per role hierarchy). */
export const Roles = (...roles: RoleName[]) => SetMetadata(ROLES_KEY, roles);
