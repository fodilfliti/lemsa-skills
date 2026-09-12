# Layer import matrix (lab)

| Layer | May import |
| --- | --- |
| `domain/` | Dart, stubs/core (failures + extensions) |
| `data/` | domain, stubs, dio/retrofit in adapters only |
| `state/` | domain, data, riverpod — never pages/controllers |
| `controllers/` | domain, data contracts, page_kit + validators stubs — **never riverpod** |
| `pages/` | controllers, state, widgets, flutter — wire `nav` + `notices` providers |

Field controllers live on `PageData` (`text()` / `flag()` / `keep()`). See [page-data.md](page-data.md).

## Folder layout (feature_first)

```text
lib/features/<name>/
  domain/
  data/
    api/          # Retrofit (S11)
    dto/
    mappers/
    sources/
  state/
  controllers/
  pages/
  widgets/
```

## Backend swap

One override in `state/*_providers.dart`:

```dart
@Riverpod(keepAlive: true)
TaskSource taskSource(Ref ref) => MockTaskSource(); // swap impl
```

Pages and `TaskRepository` stay unchanged.
