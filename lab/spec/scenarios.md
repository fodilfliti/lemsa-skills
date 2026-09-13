# Lab scenarios

## Portfolio (S-portfolio-*)

### S-portfolio-01 — multi-model navigation

**Goal:** Recruiter sees Tasks, Projects, Labels, Inbox, Profile as distinct features.

**Done when:** Home shell has five destinations; each list loads on mock.

### S-portfolio-02 — paged projects

**Goal:** `PagedList` + load-more / refresh on Projects.

**Files:** `features/projects/**`, `test/features/projects/project_form_harness_test.dart`

**Done when:** PageHarness create works; list pages beyond first page.

### S-portfolio-03 — backend switch without UI edits

**Goal:** `LAB_BACKEND` selects TaskSource via factory.

**Files:** `core/backend/*`, `test/core/backend_factory_test.dart`, README “Switch backend”

**Done when:** Factory test covers mock/rest/supabase/firebase; default mock analyze+test green.

### S-portfolio-04 — kit surface login + form

**Goal:** FormPage + EmailField/PasswordField login; FormPage + Money/Date project form.

**Done when:** Widget smoke (login) + project harness green.

---

## Classic sandbox S01–S12

Each entry: **goal**, **files**, **done when**, **do not**.

Stubs under `lib/stubs/` are **retired** (T20) — use kit imports.

---

## S01 — test core failures

**Goal:** `AppFailure` hierarchy, per-step catch in controller, redacted logging.

**Files:** `lemsa_core_kit`, `lib/core/logging/app_logger.dart`, `test/core/failures_test.dart`

**Done when:** analyze + test green; logs scrub emails via `redact`.

**Do not:** empty `catch (e) {}`.

---

## S02 — test page harness

**Goal:** `PageHarness` mounts mixin, keyed `busy.of`, field factories, inline `LemsaLoader` on save.

**Files:** `flutter_page_kit`, `test/core/page_data_test.dart`, `test/features/tasks/task_form_harness_test.dart`

**Done when:** harness + page_data tests pass.

**Do not:** import Riverpod in controller; override `dispose()` in a feature mixin.

---

## S03 — test task list flow

**Goal:** domain → repository → provider → `AsyncView` list.

**Files:** `features/tasks/**`

**Done when:** list renders mock tasks; loading uses `LemsaLoader`.

---

## S04 — test task form flow

**Goal:** controller mixin + FormPage; inline validation; busy lock.

**Files:** `controllers/task_form_data.dart`, `pages/add_task_page.dart`

---

## S05 — test mock backend

**Goal:** MockTaskSource via factory / provider.

---

## S06 — test supabase path (explicit)

**Goal:** `SupabaseTaskSource` behind `TaskSource`; `LAB_BACKEND=supabase`.

**Do not:** add credentials to repo.

---

## S07 — test drift path

**Goal:** Drift local cache + outbox + `CachedTaskRepository`.

---

## S08 — test firebase path (explicit)

**Goal:** `FirebaseTaskSource` stub/fallback; `LAB_BACKEND=firebase`.

---

## S09 — test nav + auth guard

**Goal:** auto_route + AuthGuard / GuestGuard from `flutter_nav_kit`.

---

## S10 — test i18n

**Goal:** slang keys for new features.

---

## S11 — test retrofit / REST path

**Goal:** `RestTaskSource` with Dio + `runDio` (JSONPlaceholder).

---

## S12 — test loon path

**Status:** obsolete for showcase (optional); prefer Drift cache (S07).
