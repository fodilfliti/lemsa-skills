import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../i18n/strings.g.dart';

/// Map [AppFailure] to slang strings at the render site.
String failureText(AppFailure failure) {
  return switch (failure) {
    NetworkFailure() => t.errors.network,
    TimeoutFailure() => t.errors.network,
    CancelledFailure() => '',
    NotFoundFailure() => t.errors.notFound,
    AuthFailure() => t.errors.unknown,
    PermissionFailure() => t.errors.unknown,
    ValidationFailure(:final fields) =>
      t.errors.validation(field: fields.keys.join(', ')),
    ConflictFailure() => t.errors.unknown,
    ServerFailure() => t.errors.unknown,
    StorageFailure() => t.errors.unknown,
    UnknownFailure() => t.errors.unknown,
  };
}
