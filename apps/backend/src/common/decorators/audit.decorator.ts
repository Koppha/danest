import { SetMetadata } from '@nestjs/common';

export const AUDIT_ACTION_KEY = 'auditAction';

/** Opt-in marker: the AuditInterceptor writes a baseline audit_logs row for this route. */
export const Audit = (action: string) => SetMetadata(AUDIT_ACTION_KEY, action);
