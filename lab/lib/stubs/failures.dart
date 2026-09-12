// Stubs until lemsa_core_kit ships. Do not copy into kit repos on promotion.

sealed class AppFailure implements Exception {
  const AppFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(this.field);

  final String field;
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure();
}

final class CancelledFailure extends AppFailure {
  const CancelledFailure();
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([this.cause]);

  final Object? cause;
}

String failureMessage(AppFailure failure) {
  return switch (failure) {
    NetworkFailure() => 'Network error',
    ValidationFailure(:final field) => 'Invalid $field',
    NotFoundFailure() => 'Not found',
    CancelledFailure() => '',
    UnknownFailure() => 'Something went wrong',
  };
}
