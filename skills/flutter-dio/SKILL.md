---
name: flutter-dio
description: >
  Dio REST client with interceptors and AppFailure mapping in Lemsa apps. Use
  for retrofit APIs, Firebase JWT bearer auth, web CORS proxy, or
  flutter_data_kit_dio setup.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter Dio (Lemsa)

Versions: `dio` 5.11.0, `retrofit` 4.10.0, `json_annotation` 4.9.0, `json_serializable` 6.14.1.

## Client

Use `flutter_data_kit_dio`:

```dart
final dio = buildDioClient(baseUrl, interceptors: [
  FailureInterceptor(),      // DioException → AppFailure
  TokenInterceptor(getToken),
  LoggingInterceptor(),
]);
```

## Retrofit + json_annotation

Default for `backend: rest` and `codegen.http: retrofit` in lemsa.yaml.

```text
data/api/       @RestApi client — factory ApiClient(Dio dio, {String baseUrl})
data/dto/       @JsonSerializable wire models only
data/mappers/   Dto ↔ domain — explicit functions, no Map wrappers
data/sources/   TaskSource impl calls ApiClient, maps to domain
```

```dart
@RestApi(baseUrl: 'https://api.example.com')
abstract class TaskApi {
  factory TaskApi(Dio dio, {String baseUrl}) = _TaskApi;
  @GET('/tasks')
  Future<List<TaskDto>> listTasks();
}
```

Generate: `dart run build_runner build --delete-conflicting-outputs`.

- **Repository** imports `TaskSource` only — never Retrofit.
- **Controller** sees domain models — never DTOs.
- Errors: Dio → `FailureInterceptor` → `AppFailure` at adapter boundary.

Load `lemsa-pub-deps` when adding retrofit_generator — run compatibility gate.

## Token

kiwash pattern: Firebase `currentUser.getIdToken()` → `Authorization: Bearer`.

Inject `getToken` callback — adapter does not import Firebase unless `_firebase` bridge used.

## Web CORS

`--dart-define=API_PROXY_URL=...` for web dev proxy — same as kiwash.

## Repository

Repositories call sources; sources throw AppFailure. No try/catch in notifiers.

## Do not

- Catch DioException outside adapter
- Use Dio in controller mixins
- Leave retrofit in pubspec with zero generated usage (lightnessword today)
