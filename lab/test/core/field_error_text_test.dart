import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/core/failures/field_error_text.dart';
import 'package:lemsa_lab/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.en));

  test('fieldErrorText maps codes to slang', () {
    expect(fieldErrorText(null), isNull);
    expect(fieldErrorText('required'), 'Required');
    expect(fieldErrorText('email'), 'Invalid email');
    expect(fieldErrorText('minLength', n: 3), 'At least 3 characters');
    expect(fieldErrorText('passwordMismatch'), 'Passwords do not match');
    expect(fieldErrorText('form'), 'Check the form');
    expect(fieldErrorText('unknown-code'), 'Check the form');
  });
}
