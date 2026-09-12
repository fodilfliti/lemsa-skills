# Architecture quick reference

## Feature folder

```text
features/debt/
  domain/       debt_model.dart, debt_draft.dart, debt_query.dart
  data/         debt_source.dart, debt_repository.dart
  state/        debt_providers.dart    ← all @riverpod
  controllers/  debt_form_data.dart    ← mixin, NO riverpod
  pages/        add_debt_page.dart     ← bridge getters
  widgets/      debt_card.dart, debt_info_step.dart
```

## Page bridge (only Riverpod on the screen)

```dart
@override DebtRepository get debts => ref.read(debtRepositoryProvider);
@override void onSaved(DebtModel d) => ref.read(debtListProvider.notifier).upsert(d);
```

## Controller (no riverpod)

```dart
mixin DebtFormData<T extends StatefulWidget> on State<T>, PageData<T> {
  DebtRepository get debts;
  void onSaved(DebtModel debt);
  late final title = text();
  Future<void> submit() => run(key: 'save', () async { /* per-step catch */ });
}
```

## Loading

- **Read:** `AsyncView(value: ref.watch(listProvider), data: ...)`
- **Write:** `busy.of('save')`, `run(key: 'save', ...)`
- Never one page-wide bool for both

## Errors

- Adapters throw `AppFailure`
- Controller catches per step; `run()` is outer net only
- No `catch (e) {}`

## List updates (lemsa.yaml `list_updates`)

1. **callback** (default) — `onSaved` → `upsert`
2. **pop_result** — caller upserts after `nav.push`
3. **change_stream** — only when 3+ screens must react

## ref.listen

Allowed: toast, dialog, haptics, scroll, refresh on push.
Banned: navigation (use guard), copying state into controller fields.

## State lifetime

- App: session, theme, repos → keepAlive (no user data in memory)
- Session: watch userId from session
- Page: autoDispose default
- Restart persistence: Drift / prefs / secure storage — not providers
