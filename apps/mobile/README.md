# De Nest — Mobile App

Flutter client (Android + Windows) for the De Nest Car Wash point-of-sale and loyalty system.

See the monorepo root [README](../../README.md) for full setup instructions.

## Quick start

```bash
flutter pub get
flutter run -d <device-id>
```

## Structure

- `lib/app/` — app bootstrap, router, theme
- `lib/design_system/` — shared navy/blue UI kit (cards, buttons, status pills)
- `lib/data/` — remote API client, local Drift offline database, repositories
- `lib/domain/` — entities and repository interfaces
- `lib/features/` — one folder per screen/workflow (new_wash, wash_queue, customers, prepaid, admin, ...)
