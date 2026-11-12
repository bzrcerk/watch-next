# TASKS.md — WatchNext (Lab 2)

Who builds what, in which order. Names, endpoints and models are in `SPEC.md`; owners are in `TEAM.md`.
Tick a box only when its PR is **merged** (after the partner's review, R2). Each line ends with its requirement numbers.

**Rule from the handout:** build against the **fakes first**. After phase 1 the app runs with `--dart-define=USE_FAKES=true`, and it must keep running that way to the end (the defence machine has no network).

---

## Phase 0 — Set-up (day 1, together, ~2 h)

- [ ] Create the GitHub repo (one per pair); both are collaborators; protect `main` (no direct pushes) — **Nikita** · R2
- [ ] `flutter create watch_next`; add `flutter_lints`, `unawaited_futures`, `avoid_print` to `analysis_options.yaml` — **Nikita** · R37
- [ ] Create the MockAPI project and the `watchlist` resource with the `WatchEntry` fields; put the base URL into `TEAM.md` — **Amina** · R8
- [ ] Postman: TVMaze search + detail + a 404 → `docs/` — **Nikita**
- [ ] Postman: MockAPI list / create (201) / update / delete → `docs/` — **Amina**
- [ ] Fill `TEAM.md` (names, emails, split, workflow) and commit it — **both** · R1
- [ ] Agree on the contracts in `TEAM.md` §3 and merge the empty signatures — **both**

## Phase 1 — Foundations + fakes (days 2–4)

**Nikita**
- [ ] `ApiException` (sealed, 6 subclasses) — R6
- [ ] `ApiClient`: `Uri.https`, `kRequestTimeout`, `_send` / `_check` / `_decode`, Bearer header, debug-only `log(name: 'api')` with method, path, status, time — R5, R9, R11
- [ ] `tool/check_layers.sh` — R10
- [ ] Shared views: `LoadingView`, `ErrorView`, `EmptyView`, `StaleBanner` — R21
- [ ] `Show` + `ShowImage`, `Network`, `Country`, `Schedule` with `fromJson` / `toJson` / `copyWith`; `plainSummary`, `yearsLabel`, `isRunning` — R13–R16
- [ ] `ShowsRepository` interface + `FakeShowsRepository(fail:, delay:)` — R7
- [ ] `ShowsModel` — R17
- [ ] Tests 1, 2, 3, 4 (SPEC §10) — R35

**Amina**
- [ ] `SecureStore` (**first, same day**: A's `ApiClient` needs it) — R29
- [ ] `WatchStatus` enum + `WatchEntry` with `fromJson` / `toJson` / `copyWith`; `progress`, `isFinished` — R13–R16
- [ ] `WatchlistRepository` interface + `FakeWatchlistRepository(fail:, delay:)` (create / update / delete work in memory) — R7
- [ ] `WatchlistModel` with `sorted` and `contains` — R17
- [ ] `routes.dart` + `main.dart` composition root with `Env.useFakes` — R19, R28
- [ ] Tests 9, 10, 11, 12, 13 — R35, R36

✅ Checkpoint: `flutter run --dart-define=USE_FAKES=true` opens; `flutter test` is green; `check_layers.sh` prints nothing.

## Phase 2 — Screens on fakes (days 5–7)

**Nikita**
- [ ] Shows list: search with debounce, four states, `RefreshIndicator`, exhaustive error switch — R21, R22
- [ ] Grid at ≥ 600 px via `LayoutBuilder` — R27
- [ ] Show detail: nested data, `launchUrl` (bool checked), "Add to watchlist" with `select` + comment, TVMaze credit — R18, R27
- [ ] Leaving the list mid-search keeps the console clean — R12
- [ ] Test 8 (widget: shows error + Retry) — R35

**Amina**
- [ ] Watchlist screen: four states, delete with `showDialog<bool>`, tap → form — R21, R23
- [ ] Entry form: all fields, dropdown, two date pickers, validators, keyboard, `PopScope`, `pop(saved)` — R24, R25
- [ ] Save button disabled + small spinner in flight; double tap = one request — R26
- [ ] `NavigationBar`: Shows · Watchlist · Settings — R28
- [ ] Test 15 (widget: watchlist error + Retry) — R35

✅ Checkpoint: the whole app works with fakes; you can add a show from the detail screen and see it in the watchlist.

## Phase 3 — Real APIs + storage (days 8–10)

**Nikita**
- [ ] `HttpShowsRepository`: search unwraps `{score, show}`; detail; bad JSON → `BadResponseException('shows.<field>: …')` — R7, R15
- [ ] `ShowsCache` in Documents; return the cache with `fromCache: true` on `NoConnectionException`; with no cache, the honest offline view — R30
- [ ] `SettingsModel` (dark, hide ended) + settings screen; read before `runApp` — R20, R32
- [ ] Tests 5, 6, 7 (`MockClient` 404 / 500 / SocketException) — R35

**Amina**
- [ ] `HttpWatchlistRepository`: getAll / getById / create (201) / update / delete — R8, R15
- [ ] `AuthModel` + login screen; first screen depends on the token; sign out clears it — R26, R28, R29
- [ ] Test 14 (`MockClient` create / delete) — R35

✅ Checkpoint: real data on the emulator and on a phone; airplane mode shows the cached search with the banner.

## Phase 4 — Device + polish (days 11–12)

**Nikita**
- [ ] `env.dart` (`SHOWS_HOST`, `WATCHLIST_HOST`, `ENV`, `USE_FAKES`), `env/local.json`, `env/prod.json` — R41
- [ ] About screen: version (build), mode, env, hosts, licences, TVMaze credit — R41
- [ ] Developer host field only behind `kDebugMode` — R41
- [ ] `docs/packages.md`: one verdict per package (from pub.dev) — R33

**Amina**
- [ ] Profile photo: `image_picker` + `permission_handler`, all statuses, own dialog → `openAppSettings()`, Cancel handled, survives a restart — R31, R32
- [ ] Manifest + Info.plist: only the permissions used, iOS usage strings, `<queries>` — R42
- [ ] `docs/trace.md`: plant a crash, annotate message / first own frame with column / path — R38

**Both**
- [ ] No `build()` over 60 lines; one class per file; `test/` mirrors `lib/` — R34
- [ ] `flutter analyze` 0 · `dart format .` clean · both outputs pasted in README — R37

## Phase 5 — Release (days 13–14)

**Nikita** (v1.0.0)
- [ ] `applicationId = kz.<name>.watchnext`; sdk / version from `flutter.*` — R39
- [ ] `.gitignore` first, then the keystore (outside the repo) + `key.properties`; release signed; `keytool -printcert` → `docs/` — R40
- [ ] Build `--release --split-per-abi --obfuscate --split-debug-info`; archive the symbols; GitHub Release **v1.0.0** with the arm64 APK — R43, R44
- [ ] `CHANGELOG.md` entry v1.0.0 — R4

**Amina** (v1.0.1)
- [ ] Own icon (adaptive) + splash (Android 12) + display name "WatchNext" — R42
- [ ] Bump to `1.0.1+2`; build; GitHub Release **v1.0.1** — R39, R43, R44
- [ ] `CHANGELOG.md` entry v1.0.1 — R4

**Both**
- [ ] Install the APK from the file on a real phone over mobile data; check login, search, offline, add, edit, delete, photo, About — R43
- [ ] Fourteen-box checklist in README (from the lecture), every box with proof — R44
- [ ] README: what it is, two screenshots, run lines incl. `USE_FAKES`, architecture in five lines, test count, team table, "Decisions" (8–12 sentences, owner after each) — R45

## Phase 6 — Defence prep (last 2–3 days)

- [ ] `git shortlog -sn` → `TEAM.md`; both ≥ 35 % — R3
- [ ] Each person explains the partner's whole area to them (the defence asks about both)
- [ ] Each person does every pool task from **SPEC §11** in their own area on a throw-away branch: offline, `USE_FAKES=true`, no AI, 10-minute timer
- [ ] Pool 14 + 15 together: one of you plants a defect (`catch (e) {}`, `as double` on an int, `read` in `build`, a missing `mounted`, a Future in `build`, Temporary for user data), the other finds it from the symptom and writes the red test first
- [ ] Pool 16 together: bump the patch, build with `env/prod.json`, show the new version in About on the phone

---

### Balance check

| | Nikita | Amina |
|---|---|---|
| Feature | Shows: search, cache, grid, detail | Watchlist: full CRUD, form |
| Core | `core/api`, shared views, env | secure storage, routes, `main.dart` |
| Device / settings | settings, About | auth, profile photo, permissions |
| Release | signing, v1.0.0 | icon, splash, v1.0.1 |
| Tests | 1–8 | 9–15 |
| Docs | `packages.md`, Postman TVMaze | `trace.md`, Postman MockAPI |
