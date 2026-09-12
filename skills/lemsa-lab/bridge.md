# Bridge — nav, notices, mappers (lab)

Controllers never touch `Navigator`, `ScaffoldMessenger`, or `BuildContext` tricks. The **page** wires two global services plus mappers.

## PageBridge (form pages)

Lab: `lab/lib/core/bridge/page_bridge.dart` → ships in `flutter_page_kit` or app bootstrap.

Mix **before** feature `*FormData` on `ConsumerState` — provides `nav` + `notices` automatically:

```dart
class _AddTaskPageState extends ConsumerState<AddTaskPage>
    with PageBridge, PageData<AddTaskPage>, TaskFormData<AddTaskPage> {

  @override TaskRepository get taskRepository => ref.read(taskRepositoryProvider);
  // nav + notices from PageBridge
}
```

List/detail pages without a controller mixin do **not** use `PageBridge` — call `ref.read(navigatorProvider)` inline.

## PageNavigator (typed nav)

Stub: `lab/lib/stubs/page_navigator.dart` → ships as `flutter_page_kit` + `flutter_nav_kit`.

```dart
// controller — no auto_route import
nav.pop(saved);
final item = await nav.push<TaskModel>(AddTaskRoute());

// page bridge — use PageBridge mixin, or manually:
@override PageNavigator get nav => ref.read(navigatorProvider);
```

Never `Navigator.of(context).pop()` in a mixin.

## Notices (snackbar / toast)

Stub: `lab/lib/stubs/notices.dart` → ships as `flutter_app_kit`.

```dart
// controller
notices.error(failureText(f));
notices.showFailure(failure);   // skips CancelledFailure
notices.success(t.tasks.created);

// page bridge
@override Notices get notices => ref.read(noticesProvider);
```

Never `ScaffoldMessenger.of(context).showSnackBar()` in a mixin.

## failureText (mapper)

One app-owned function maps `AppFailure` → slang string. Lives in `core/failures/failure_text.dart`. Kits throw failures; apps localize.

## Page bridge checklist

Every form controller mixin declares abstract getters; the page implements them:

| Getter | Provider / source |
| --- | --- |
| repositories | `ref.read(*RepositoryProvider)` |
| `nav` | `PageBridge` mixin or `ref.read(navigatorProvider)` |
| `notices` | `PageBridge` mixin or `ref.read(noticesProvider)` |
| `onSaved` / callbacks | forward to notifier |

## Pop result vs callback

- **Callback (default):** `onSaved(task)` — list updates without pop.
- **Pop result:** `nav.pop(task)` — caller `await nav.push<R>(Route())` upserts.

Lab Task Tracker uses pop result on add form; see `spec/bridge.md` for when to pick each.

## AI codegen focus

Generate **domain**, **DTO mappers**, **repository**, **controller mixin** (`text()` / `validated`, never hand dispose), **page bridge getters** — not raw Navigator/SnackBar calls.

Field factories and `PageHarness`: read [page-data.md](page-data.md).
