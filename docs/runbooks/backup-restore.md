# Backups and restore

**Status: implemented, using a local-disk adapter by default.** The
pipeline (`apps/backend/src/modules/backups/`) is real code — `pg_dump` →
AES-256-CBC encrypt → upload → `backup_runs` bookkeeping — with a scheduled
job (`BACKUP_CRON`, default 2am daily) and a manual trigger
(`POST /api/v1/backups/run`, admin+). The Google Drive adapter is also
fully implemented but **not tested against a real Drive folder** this
session (no service account credentials were available) — see
`docs/runbooks/stubs-and-todos.md`.

## Design

- PostgreSQL is the primary database; Google Drive is used **only** for
  encrypted backup files, never for syncing live device databases.
- `BackupsService.runBackup()` runs `pg_dump --format=custom` against
  `DATABASE_URL` to produce a consistent snapshot (pg_dump never reads a
  live/mid-write file), encrypts it with `BACKUP_ENCRYPTION_KEY`
  (`backup-crypto.ts` — the round-trip is unit-tested), and uploads via
  whichever `BackupStorageAdapter` is configured.
- Adapter selection (`backups.module.ts`): `BACKUP_STORAGE_DRIVER=local`
  (default) uses `LocalDiskBackupStorage` (writes to `BACKUP_LOCAL_PATH`).
  `BACKUP_STORAGE_DRIVER=google_drive` uses `GoogleDriveBackupStorage` —
  but only once all three `GOOGLE_DRIVE_*` env vars are set; otherwise it
  falls back to `UnconfiguredGoogleDriveStorage`, which throws a clear
  error naming what's missing rather than silently doing nothing.
- Each run writes a row to `backup_runs` (status, file name, size,
  checksum, Drive file ID, error message, retention expiry).
- `BackupsRetentionScheduler` prunes local files past
  `BACKUP_RETENTION_DAYS` daily (non-local storage: bookkeeping only, no
  file to delete).

## Setting up Google Drive (once you have a Google Cloud project)

See the step-by-step comment block above `GOOGLE_DRIVE_CLIENT_EMAIL` in
`apps/backend/.env.example` — briefly: create a service account, download
its JSON key, share a Drive folder with the service account's email as
Editor, and set the three env vars from that JSON + the folder's ID.

## Manual backup

```bash
# Via the API (admin+):
curl -X POST http://localhost:3000/api/v1/backups/run -H "Authorization: Bearer $TOKEN"
curl http://localhost:3000/api/v1/backups -H "Authorization: Bearer $TOKEN"   # check status

# Or directly, if you just want a one-off dump outside the app:
pg_dump "$DATABASE_URL" --format=custom --file=backup.dump
openssl enc -aes-256-cbc -salt -in backup.dump -out backup.dump.enc -k "$BACKUP_ENCRYPTION_KEY"
```

## Restore procedure (owner only)

1. Download the encrypted backup file (from Google Drive, or
   `BACKUP_LOCAL_PATH` if using local storage).
2. Decrypt it: `openssl enc -d -aes-256-cbc -in backup.dump.enc -out backup.dump -k "$BACKUP_ENCRYPTION_KEY"`.
3. Stop the backend so nothing writes to the database during restore.
4. Restore into a **fresh** database first to verify integrity, not
   directly over production:
   `pg_restore --clean --if-exists --dbname="$DATABASE_URL" backup.dump`
5. Once verified, point the backend at the restored database and restart.
6. This action must be logged in `audit_logs` (action `BACKUP_RESTORED`)
   per the spec — not yet wired automatically into a restore command
   (there isn't one yet, restore above is manual); note it manually for
   now, or add an owner-only `POST /api/v1/backups/restore` endpoint that
   calls `AuditService.record()` before/after running the `pg_restore`
   step above.
