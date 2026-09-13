import 'package:flutter_test/flutter_test.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import 'package:lemsa_lab/core/failures/failure_text.dart';
import 'package:lemsa_lab/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.en));

  group('failureText', () {
    test('covers validation fields', () {
      expect(
        failureText(const ValidationFailure({'title': 'invalid'})),
        'Invalid title',
      );
    });

    test('cancelled has empty message', () {
      expect(failureText(const CancelledFailure()), '');
    });

    test('network maps to slang', () {
      expect(failureText(const NetworkFailure()), 'Network error — try again');
    });
  });
}
