import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/stubs/validators.dart';

void main() {
  group('Validators.required', () {
    test('empty and whitespace fail', () {
      expect(Validators.required(''), 'required');
      expect(Validators.required('   '), 'required');
    });

    test('non-empty passes', () {
      expect(Validators.required('ok'), isNull);
    });
  });

  group('Validators.minLength', () {
    final rule = Validators.minLength(3);

    test('too short fails', () {
      expect(rule(''), 'minLength');
      expect(rule('ab'), 'minLength');
      expect(rule('  ab  '), 'minLength');
    });

    test('long enough passes', () {
      expect(rule('abc'), isNull);
      expect(rule('abcd'), isNull);
    });
  });

  group('Validators.email', () {
    test('empty defers to required', () {
      expect(Validators.email(''), isNull);
    });

    test('invalid / valid', () {
      expect(Validators.email('not-an-email'), 'email');
      expect(Validators.email('a@b.c'), isNull);
    });
  });

  group('Validators.all', () {
    final rules = [Validators.required, Validators.minLength(3)];

    test('first failure wins', () {
      expect(Validators.all('', rules), 'required');
      expect(Validators.all('ab', rules), 'minLength');
      expect(Validators.all('abc', rules), isNull);
    });
  });
}
