# Lab scenarios S01–S12

Each entry: **goal**, **files**, **done when**, **do not**.

---

## S01 — test core failures

**Goal:** `AppFailure` hierarchy, per-step catch in controller, redacted logging.

**Files:** `lib/stubs/failures.dart`, `lib/core/logging/app_logger.dart`, `test/core/failures_test.dart`

**Done when:** analyze + test green; logs scrub emails via `redact`.

**Do not:** empty `catch (e) {}`.

---

## S02 — test page harness

**Goal:** `PageHarness` mounts mixin, keyed `busy.of`, field factories (`text`/`flag`/`keep`), inline `LemsaLoader` on save.

**Files:** `lib/stubs/page_kit.dart`, `lib/stubs/core/`, `test/core/page_data_test.dart`, `test/features/tasks/task_form_harness_test.dart`

**Done when:** harness + page_data tests pass; save key toggles busy independently; unmount disposes registry in reverse order.

**Do not:** import Riverpod in controller; override `dispose()` in a feature mixin.

---

## S03 — test task list flow

**Goal:** domain → repository → provider → `AsyncView` list.

**Files:** `features/tasks/domain/*`, `data/task_repository.dart`, `state/task_providers.dart`, `pages/task_list_page.dart`

**Done when:** list renders mock tasks; loading uses `LemsaLoader`.

**Do not:** Map wrappers in repository public API.

---

## S04 — test task form flow

**Goal:** controller mixin uses `text(validators:)` + `validated` + `validateForm`; page maps `errorCode` via `fieldErrorText`; cross-field confirm; busy lock.

**Files:** `controllers/task_form_data.dart`, `pages/add_task_page.dart`, `stubs/validators.dart`, `core/failures/field_error_text.dart`

**Done when:** submit upserts; empty / too-short / mismatch blocked with `errorText`; while saving, fields and pop are locked.

**Do not:** Riverpod in controller; `t.*` in validators; hand `dispose()`; build `flutter_input_kit` widgets.

---

## S05 — test mock backend

**Goal:** `MockTaskSource` swappable via provider override.

**Files:** `data/sources/mock_task_source.dart`, `state/task_providers.dart`

**Done when:** override test proves swap without page changes.

**Do not:** wire Supabase by default.

---

## S06 — test supabase path (explicit)

**Goal:** `SupabaseTaskSource` stub behind `TaskSource`.

**Files:** `data/sources/task_source_supabase.dart`

**Done when:** stub compiles; provider override documented.

**Do not:** add credentials to repo.

---

## S07 — test drift path

**Goal:** Drift local cache + outbox + `CachedTaskRepository` + reactive `watch()` stream.

**Files:** `core/database/*`, `data/local/drift_task_local_store.dart`, `data/cached_task_repository.dart`, `test/features/tasks/cached_task_repository_test.dart`

**Done when:** offline create shows pending badge; sync flushes; sign-out wipes DB.

**Do not:** use Riverpod as cache of record.

## S08 — test firebase path (explicit)

**Goal:** `FirebaseTaskSource` stub.

**Files:** `data/sources/task_source_firebase.dart`

**Done when:** stub compiles.

---

## S09 — test nav + auth guard

**Goal:** auto_route + session mock (incremental).

**Do not:** implement until nav kit stub exists.

---

## S10 — test i18n

**Goal:** slang keys on task strings (incremental).

---

## S11 — test retrofit path (explicit)

**Goal:** Retrofit client + DTO + mapper + REST source.

**Files:** `data/api/task_api.dart`, `data/dto/task_dto.dart`, `data/mappers/task_mapper.dart`, `data/sources/task_source_rest.dart`

**Done when:** build_runner green; REST source maps DTO → domain.

---

## S12 — test loon path (explicit)

**Goal:** Loon cache adapter — **only when user asks**.

**Files:** `data/sources/task_source_loon.dart`

**Do not:** add `loon` to pubspec unless triggered.
