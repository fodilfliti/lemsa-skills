import '../../../stubs/failures.dart';
import '../../i18n/strings.g.dart';

/// Map [AppFailure] to slang strings at the render site.
String failureText(AppFailure failure) {
  return switch (failure) {
    NetworkFailure() => t.errors.network,
    ValidationFailure(:final field) => t.errors.validation(field: field),
    NotFoundFailure() => t.errors.notFound,
    CancelledFailure() => '',
    UnknownFailure() => t.errors.unknown,
  };
}
