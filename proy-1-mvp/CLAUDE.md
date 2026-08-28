# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

The MVP for an HCI (IHC) university project: a mobile app that lists current events in Santa Cruz de la Sierra so a person can compare options (what / when / how much / where) and share one to a WhatsApp group without leaving the app.

`prd/prd-v0.1.md` is the source of truth for scope. The code implements it; when they disagree, the PRD wins unless the user says otherwise.

```
proy-1-mvp/
├── prd/prd-v0.1.md      scope, requirements (FR-*), metrics (KR*), open questions (OQ-*)
├── api/                 NestJS + Prisma
├── app/                 Flutter
└── docker-compose.yml   PostgreSQL on port 5433
```

## Commands

```bash
docker compose up -d                    # Postgres

cd api
npm run start:dev                       # API on http://localhost:3000/api
npm run build                           # tsc via nest — the only correctness gate here
npm run db:seed                         # 24 seed events, dates relative to now
npm run db:reset && npm run db:seed     # wipe and reload
npx prisma migrate dev --name <name>    # after editing schema.prisma

cd app
flutter analyze                         # must stay at "No issues found!"
flutter run
flutter run --dart-define=API_BASE_URL=http://<ip>:3000/api   # physical device
```

**There are no tests, by the user's explicit decision.** Do not add `*.spec.ts`, `*_test.dart`, or a test runner. Verify with `npm run build`, `flutter analyze`, and real requests against the running API instead.

Postgres is on **5433**, not 5432, to avoid colliding with a local install.

## Architecture

No clean architecture, no hexagonal — a deliberate decision for a two-person MVP on a course calendar. Each framework is used as it ships.

**API** — plain Nest modules (`module` / `controller` / `service`) with Prisma as data access. No ports, adapters, or use cases.

- `events/` — FR-01 to FR-05, FR-10 to FR-12
- `interests/` — FR-08, FR-09
- `common/` — validity rules, Bolivia time windows, haversine, the device-id decorator

**App** — feature-first, `ChangeNotifier` + `provider`. The one rule that is enforced: **widgets never speak HTTP**. `api/api_client.dart` and `api/event.dart` are the only files that know the JSON shape, so a contract change touches two files, not twelve.

### Things that will bite you

- **Route order matters**: `GET /events/mine` is declared before `GET /events/:id` in `events.controller.ts`. Reversing them makes Nest parse `mine` as an event id.
- **`api/tsconfig.json` has `include: ["src/**/*"]`** on purpose. Without it `prisma/seed.ts` joins the program, tsc raises `rootDir`, and the build emits `dist/src/main.js` instead of `dist/main.js`.
- **No `dart:io` in `app/lib/`** — it breaks the web build. Network failures are detected by catching everything that is not an `ApiException`.
- **Bolivia is UTC-4 with no DST**, so `common/time.ts` uses a fixed offset to compute "today" and "this weekend" in local wall-clock time. Do not swap in UTC math.
- **`usesCleartextTraffic` is on** in the Android manifest because the dev API is http. It is MVP-only and must come off before any real deployment.

## Non-negotiable product rules

These come from the PRD. Violating one changes the product, not just the code:

- **The list is the home screen.** No search-first, no onboarding. The card carries name, price (or "Gratis" — never blank), date/time, and location/distance, so comparison happens *in the list*.
- **No accounts, no personal data.** Identity is a local device UUID sent as the `X-Device-Id` header. It is also what authorizes editing an event.
- **The flow ends outside the app on purpose.** Native share sheet, device map app, decision in WhatsApp. Time-in-app is an anti-goal.
- **Interest is a number, never a list of names**, lives in the detail (not the card), and the UI must never say "Voy"/"Asistiré" — the app cannot verify attendance.
- **A cancelled event stays visible, marked.** It never disappears silently.
- **Accessibility is a requirement, not polish**: WCAG AA, ≥48dp touch targets, primary actions in the lower third, text scaling to 200%, and price/validity never signalled by color alone.

## Evidence honesty

All research behind the PRD is **AI-simulated**, and every document says so. Keep it that way: never present a simulated finding as validated, keep unsupported requirements marked as design decisions (FR-08/09/11 are the standing example), and do not close an `OQ-*` by writing an answer into the PRD — that is the user's call.

Requirement IDs (`FR-*`, `KR*`, `OQ-*`, `R-*`, `JTBD-*`, `M*`) are stable and cross-referenced across sections and code comments. Never renumber them.

Decisions already taken against open questions are recorded in `README.md`: OQ-1 (device UUID), OQ-4 (device owns the event), OQ-8 (no image on the card), OQ-9 (zone as distance origin, no GPS), OQ-3 (no counter threshold).

## Conventions

Documents, UI copy, and code comments are in **Spanish** (local register, no jargon). Identifiers and types are in English. Doc filenames are versioned `<nombre>-v<major>.<minor>.md`; a new version is a new file plus a row in the version-history table.

`.atl/skill-registry.md` is auto-generated (`gentle-ai skill-registry refresh --force`) — pass matching `SKILL.md` paths to subagents, never summaries. Do not hand-edit it.
