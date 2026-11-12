# TEAM.md — WatchNext

> Split chosen: **by feature** (option 1 in the handout, section 4). Details: `SPEC.md`, plan: `TASKS.md`.

| Name | GitHub | Role |
|---|---|---|
| **Nikita** | [@bzrcerk](https://github.com/bzrcerk) | shows (catalogue), core/api, settings, release v1.0.0 |
| **Amina** | [@llifwx](https://github.com/llifwx) | watchlist (collection), auth, storage, release v1.0.1 |

**App:** WatchNext, a TV-series tracker
**Catalogue:** TVMaze (`https://api.tvmaze.com`), public, read-only, no key
**Collection backend:** MockAPI.io, resource `watchlist`, base URL: `https://TODO.mockapi.io/api/v1/watchlist`

---

## 1. Owners

| Area | Folder / files | Owner | Reviewer |
|---|---|---|---|
| Networking core | `lib/core/api/` (ApiClient, ApiException) | **Nikita** | Amina |
| Shared views | `lib/core/widgets/` | **Nikita** | Amina |
| Environment | `lib/core/env.dart`, `env/` | **Nikita** | Amina |
| **Shows (catalogue)** | `lib/features/shows/` | **Nikita** | Amina |
| Settings + About | `lib/features/settings/` (except the photo) | **Nikita** | Amina |
| Secure storage | `lib/core/storage/` | **Amina** | Nikita |
| Routes + composition root | `lib/core/routes.dart`, `lib/main.dart` | **Amina** | Nikita |
| **Watchlist (collection)** | `lib/features/watchlist/` (incl. the entry form) | **Amina** | Nikita |
| Auth | `lib/features/auth/` | **Amina** | Nikita |
| Profile photo | `lib/features/settings/profile_photo.dart` | **Amina** | Nikita |
| Tests | `test/` mirrors `lib/`; each tests their own folders (SPEC §10) | Nikita + Amina | the other |
| Layer check | `tool/check_layers.sh` | **Nikita** | Amina |
| Release v1.0.0 | applicationId, signing, first build | **Nikita** | Amina |
| Release v1.0.1 | icon, splash, permissions, version bump | **Amina** | Nikita |
| Docs | `docs/packages.md` (Nikita), `docs/trace.md` (Amina), Postman (each their API) | Nikita + Amina | the other |

## 2. Contracts — agreed on day 1

| Contract | Written by | Used by |
|---|---|---|
| `SecureStore.readToken() → Future<String?>` | Amina | Nikita (`ApiClient`) |
| `ApiClient.get / post / put / delete` + the `ApiException` subclasses | Nikita | Amina (`HttpWatchlistRepository`, the watchlist screen's switch) |
| `LoadingView`, `ErrorView`, `EmptyView`, `StaleBanner` | Nikita | Amina (watchlist screen) |
| `WatchlistModel.create(WatchEntry)` and `contains(int showId)` | Amina | Nikita ("Add to watchlist" on the show detail) |
| How a `Show` becomes a new `WatchEntry` (`showId`, `showName`, `posterUrl`, status `planned`, `startedAt` = today) | Amina | Nikita |
| Route names in `routes.dart` | Amina | Nikita |
| `SettingsModel.dark` (theme in `main.dart`) | Nikita | Amina |

## 3. Workflow

- Branches: `feature/<short-name>` (e.g. `feature/shows-cache`, `feature/entry-form`).
- Every change reaches `main` through a pull request. **The other person reviews**, with at least one comment on every PR that changed something (R2).
- The **author merges** after approval. Nobody pushes to `main`.
- Commit messages name the change (`add offline cache for shows search`), never `fix`, `wip`, `final` (R3).
- Commit under your own GitHub account (name and email set in `git config`); small commits often, so `git shortlog -sn` stays ≥ 35 % each.

## 4. Contributions

Paste the output of `git shortlog -sn` here on the day of the defence.

```
TODO
```

## 5. Decisions

Five to ten one-line decisions, each with the name of who made it (R1). Write them when you make them; don't invent them at the end.

| # | Decision | Owner |
|---|---|---|
| 1 | TODO | TODO |
| 2 | TODO | TODO |
| 3 | TODO | TODO |
| 4 | TODO | TODO |
| 5 | TODO | TODO |
