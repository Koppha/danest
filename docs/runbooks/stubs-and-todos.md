# Stubs, TODOs, and what's deferred

This scaffold prioritized getting the highest-risk business logic (loyalty
ledger math, split payments, prepaid safe-limits, idempotent wash
completion, cash collections) working with real tests over building every
peripheral integration end-to-end. This file tracks what's stubbed and how
to finish it.

## Needs real credentials (can't be completed without them)

- **SMS provider** — `apps/backend/src/modules/sms/providers/` has a
  working `MockSmsProvider` (logs instead of sending) wired in by default
  (`SMS_PROVIDER=mock` in `.env`). Swap in a real Africa's
  Talking/Twilio/Clickatell adapter behind the same `SmsProvider` interface
  in `sms-provider.interface.ts` once you have credentials — no other code
  needs to change.
- **Google Drive backups** — the upload adapter is fully implemented
  (`apps/backend/src/modules/backups/adapters/google-drive-backup-storage.ts`,
  using `@googleapis/drive`) and wired to activate automatically once you
  set `BACKUP_STORAGE_DRIVER=google_drive` plus the three `GOOGLE_DRIVE_*`
  values in `.env` — see the step-by-step instructions in `.env.example`.
  Until those are set, it falls back to local disk automatically. Not
  tested end-to-end against a real Drive folder in this session (no
  credentials available).
- **Production secrets** — `apps/backend/.env.example` has placeholder
  values for JWT secrets, the seed admin password, and a backup encryption
  key. Generate real values (`openssl rand -hex 32` works well) for any
  real deployment; never commit `.env`.

## Needs local infrastructure

- **Docker Compose / PostgreSQL** — `infra/docker-compose.yml` is written
  but not used this session. Instead, the backend was verified against a
  *real* Postgres via the `embedded-postgres` npm package (a self-contained
  dev-only Postgres binary, no system install) — see
  `apps/backend/scripts/start-dev-db.mjs`. Every module, the full
  auth→customer→vehicle→wash→payment→loyalty→SMS flow, and the mobile
  app's login were verified live against it. For a real deployment, use
  `infra/docker-compose.yml` instead: `cd infra && docker compose up -d
  postgres`, then `cd apps/backend && npx prisma migrate deploy` (a
  migration already exists at `prisma/migrations/0001_init/`) and `npx
  prisma db seed`.
- **Windows desktop Flutter build** — this machine's Visual Studio install
  is missing the "Desktop development with C++" workload, so `flutter
  build windows` / `flutter run -d windows` hasn't been verified. The
  Android build has been. Install the workload via the Visual Studio
  Installer, then retry.

## Built this session, lightly verified

- **Offline mode (Drift + SQLite)** — `apps/mobile/lib/data/local/` has a
  real local SQLite database (via Drift), an offline-first repository
  (`offline_pos_repository.dart`), and a sync service that drains a
  outbox against the backend when connectivity returns. Verified live on
  the Android emulator: catalog caching, offline customer/vehicle
  creation, and offline cash-wash completion all worked with the network
  disabled, with the "N queued offline" indicator updating correctly.
  Deliberately scoped: only CASH/CARD/MOBILE_MONEY/BANK_TRANSFER payments
  work offline — WALLET/PACKAGE/LOYALTY_FREE_WASH are disabled in the
  finish-wash UI when offline because they need a live balance/validity
  check the design never intended to trust to a stale local cache (see
  `docs/architecture/overview.md` for the reasoning). A real bug was found
  and fixed during this verification: `Customer.vehicles` defaulted to a
  `const []`, which threw when a screen tried to mutate it after creating
  a vehicle inline — now covered by a regression test
  (`test/models_test.dart`).
- **Sync push retry** — `SyncService.pushAll()` drains the outbox and is
  triggered automatically on reconnect and on first dashboard load; it has
  not been separately stress-tested for prolonged offline periods with
  many queued operations.

## Deliberately out of scope for this pass

- **Server-side sync push/pull protocol module** — the mobile outbox pushes
  directly against the existing create/transition/finish endpoints (which
  are already idempotent on client-generated IDs), rather than through a
  dedicated `/sync` batch endpoint with its own conflict-queue bookkeeping
  (`sync_batches`/`sync_conflicts` tables exist in the schema but aren't
  populated by anything yet). This works for the common case; a dedicated
  batch endpoint would add clearer admin-facing visibility into what's
  pending across all devices.
- **Split-payment entry in the mobile UI** — the backend fully supports
  multiple payment components summing to the wash total (and it's tested).
  The "Finish Wash" bottom sheet in the app currently only offers a single
  payment method for the full amount; extending it to a multi-row
  split-entry UI is straightforward but wasn't done in this pass.
- **Exhaustive e2e test coverage** — real unit/integration tests were
  written for the high-risk domains (auth/RBAC, wash state machine,
  payments, loyalty, prepaid, finish-wash idempotency, collections,
  offline repository, backup encryption). Lower-risk modules (services
  catalog CRUD, reports formatting, receipt upload) have thinner or no
  automated coverage.
- **iOS / macOS / Linux Flutter targets** — left as the untouched Flutter
  template scaffolding; not in the stated platform requirement (Android +
  Windows only) and not developed or verified.

## Known simplifications worth revisiting

- **Expense "date"** — the spec calls for a distinct expense date separate
  from when it was recorded; the current schema only has `createdAt`.
- **Receipt storage** — local disk under the backend, served through an
  authenticated route. Fine for a single-server deployment; swap the
  `storage-provider`-style pattern for S3/MinIO if you outgrow that.
- **Package-purchase payment linkage** — `PrepaidPackagePurchase` doesn't
  yet flow through the same `Payment`/`PaymentComponent` ledger a wash
  does; it records the payment method as a loose string. Worth unifying if
  package-purchase cash needs to show up in Collections reporting later.
