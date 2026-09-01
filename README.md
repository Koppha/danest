# De Nest Car Wash

A cross-platform (Android + Windows) point-of-sale and customer-loyalty system for De Nest Car Wash: pay-as-you-wash and prepaid customers, per-vehicle monthly loyalty, a wash queue, completion SMS, cash reconciliation, expenses, simple reports, offline operation with sync, and encrypted backups.

## Monorepo layout

```
DeNest/
├── apps/
│   ├── backend/   # NestJS + Prisma + PostgreSQL REST API
│   └── mobile/    # Flutter app (Android + Windows), Riverpod + Dio (online-only for now, see Status)
├── infra/         # docker-compose.yml, Postgres init scripts, backup scripts
├── docs/          # architecture notes, API docs, DB notes, runbooks
└── scripts/       # repo-level dev scripts
```

## Prerequisites

- Node.js 22+ and npm
- Flutter 3.x with the Android toolchain (Windows desktop builds additionally need the "Desktop development with C++" Visual Studio workload)
- Docker + Docker Compose (for PostgreSQL and the backend container) — **not installed/verified on the machine this scaffold was built on; install and verify separately.**

## Backend setup

```bash
cd apps/backend
cp .env.example .env      # then fill in real secrets
npm install
npx prisma migrate dev    # applies migrations, requires Postgres running (see infra/)
npm run start:dev
```

To start Postgres via Docker Compose:

```bash
cd infra
docker compose up -d postgres
```

API docs (Swagger/OpenAPI) are served at `/api/docs` once the backend is running.

## Mobile app setup

```bash
cd apps/mobile
flutter pub get
flutter run -d <device-id>   # e.g. an Android emulator, or `windows` once the VS C++ workload is installed
```

The app points at the backend via an API base URL configured in `lib/app/` — see `apps/mobile/README.md`.

## Roles

Attendant, Supervisor, Administrator, Owner — see `docs/architecture/` for the full permission matrix and business rules (loyalty, prepaid, cash collections, etc.).

## Status

This is a best-effort full scaffold. What's built and verified:

- **Backend**: every module from the spec is implemented — auth/RBAC (JWT + PIN overrides), customers/vehicles, services catalog, wash queue state machine, split payments, the loyalty ledger (5-wash rule, rewards, reversal walk-back), prepaid wallets/packages, idempotent "Finish Wash & Send SMS", SMS (mock provider), cash collections, expenses, reports, audit log, and a working backup pipeline (dump → encrypt → local storage, Google Drive adapter stubbed). **67 automated tests pass**, concentrated on the highest-risk logic (loyalty math, payment validation, prepaid negative-balance guards, finish-wash idempotency, cash-collection formulas). The full app boots cleanly with every route mapped — verified by actually starting it, not just `tsc`.
- **Mobile**: a real Flutter app (not the starter template) — login, dashboard, new wash, wash queue with finish/void, customers with loyalty badges, prepaid top-ups, transactions, reports, and the admin section (collections, expenses, settings, audit/SMS log), all wired to the live API via Riverpod + Dio. `flutter analyze` is clean, the widget test suite passes, and it was **built, installed, and driven on a real Android emulator** — the login screen renders with the correct navy/blue branding, and attempting to sign in correctly calls the API and surfaces a graceful error (expected, since no backend was running in that session).
- **Not verified against a real database**: Docker/PostgreSQL aren't installed on this dev machine, so the backend has been verified to boot cleanly and attempt real queries (confirmed via a deliberate connection failure), but not against live data. This sandbox also has intermittent connectivity to `dl.google.com` (Android's SDK/Gradle plugin repository) — the Android build succeeded, but expect the same flakiness on a similarly restricted network. See `docs/runbooks/stubs-and-todos.md` for the full list of what's stubbed.
