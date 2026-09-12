import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/stubs/failures.dart';

void main() {
  group('AppFailure', () {
    test('failureMessage covers validation', () {
      expect(
        failureMessage(const ValidationFailure('title')),
        'Invalid title',
      );
    });

    test('cancelled has empty message', () {
      expect(failureMessage(const CancelledFailure()), '');
    });
  });
}
