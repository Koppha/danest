# Architecture overview

## Monorepo layout

```
DeNest/
├── apps/
│   ├── backend/   # NestJS 12 + Prisma 7 + PostgreSQL, ESM/TypeScript
│   └── mobile/    # Flutter (Android + Windows), Riverpod + Dio
├── infra/         # docker-compose.yml, Postgres init
├── docs/          # this file, runbooks, API notes
└── scripts/
```

## Backend

- **Auth**: JWT access tokens (short-lived) + opaque, hashed, rotating
  refresh tokens stored in `refresh_tokens`. `JwtAuthGuard` verifies the
  bearer token directly via `JwtService` (not Passport — see below).
  Supervisor+ actions (voids, cancellations, manual loyalty adjustments)
  additionally require `PinOverrideGuard`, which checks a PIN against a
  supervisor-or-above user's `pinHash` and records who approved what.
- **Idempotency**: `IdempotencyInterceptor` caches responses by an
  `Idempotency-Key` header for routes marked `@Idempotent()` (chiefly
  "Finish Wash & Send SMS") — a retried request returns the original
  response verbatim rather than re-running side effects. Every side-effect
  table it touches (payments, loyalty ledger, wallet/package ledgers, SMS)
  also carries its own unique constraint as defense-in-depth.
- **Audit**: a hybrid of an opt-in `@Audit('ACTION')` decorator +
  `AuditInterceptor` (covers "did X call Y") and explicit
  `AuditService.record()` calls inside services where a rich before/after
  diff matters (price changes, loyalty reversal, collection confirmation).
- **Loyalty**: `loyalty_ledger` is append-only and is the only source of
  truth — "qualifying count" is always recomputed live from it, never
  stored as a mutable counter. See `modules/loyalty/loyalty.service.ts`
  for the full reasoning, including how a refund walks back a reward that
  was already earned (or flags it for review if already redeemed).
- **Prepaid**: wallet/package ledgers are append-only; balances are cached
  columns reconciled from the ledger. The offline "safe cached limit"
  design (freshness window + per-transaction cap) is documented but not
  yet wired into a sync layer — see `stubs-and-todos.md`.
- **Payments**: `PaymentsService.finishWash()` is the single orchestration
  point — validates the split-payment sum against the wash total, applies
  wallet/package/loyalty side effects inside one Prisma transaction, marks
  the wash `COMPLETED`, credits loyalty, and queues the completion SMS.
- **Why no Passport**: this NestJS install is on a very new v12 release,
  and `@nestjs/passport`'s `AuthGuard` mixin has a documented requirement
  ("import PassportModule in each place where AuthGuard() is being used")
  that doesn't fit a feature-module-per-domain layout well. `JwtAuthGuard`
  verifies tokens directly via `JwtService` instead — fewer moving parts,
  same guarantee, no per-module Passport imports needed.
- **Why Prisma 7's `prisma.config.ts`**: Prisma 7 moved the datasource
  connection string out of `schema.prisma` and into `prisma.config.ts`
  (loaded via `dotenv`), with `PrismaClient` taking a driver adapter
  (`@prisma/adapter-pg`) instead of reading the URL itself. This is a
  breaking change from earlier Prisma versions if you're following older
  tutorials/docs.

## Mobile

- **State**: Riverpod. `sessionProvider` holds the current user + tokens
  (persisted via `flutter_secure_storage`); an auth `Interceptor` on the
  shared `Dio` instance attaches the bearer token and transparently
  refreshes once on a 401 before retrying.
- **Navigation**: `go_router`, gated by a `redirect` callback that checks
  `sessionProvider` and a `ChangeNotifier` bridge that re-runs the
  redirect whenever the session changes.
- **Design system**: `lib/design_system/` — navy/blue theme tokens,
  status pills, the five-car loyalty meter, and card/KPI widgets shared
  across screens, matching the reference prototype's visual language.
- **Offline**: not implemented this pass (see `stubs-and-todos.md`) — the
  app is online-only for now. `drift`/`sqlite3_flutter_libs` were removed
  from `pubspec.yaml` because their native-asset download step failed in
  this sandbox; re-add them when building the offline layer.

## Testing

Backend: Vitest, 67 tests, concentrated on the domains identified as
highest-risk during planning — auth/RBAC, the wash order state machine,
split-payment validation, the full loyalty ledger (5th-wash detection,
reversal walk-back, cross-month reset, redeemed-then-reversed edge case),
prepaid negative-balance/idempotency guards, SMS dedup, finish-wash
idempotency, and the cash-collection expected-cash formula. Lower-risk
modules (services catalog CRUD, reports formatting) have thinner coverage.

Mobile: `flutter analyze` is clean; a widget test smoke-checks the login
screen renders its branding and fields.
