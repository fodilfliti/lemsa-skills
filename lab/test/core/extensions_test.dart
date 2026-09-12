import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/stubs/core/extensions.dart';

void main() {
  group('String?', () {
    test('isNullOrEmpty / isNotNullOrEmpty / text', () {
      String? missing;
      expect(missing.isNullOrEmpty, isTrue);
      expect(missing.isNotNullOrEmpty, isFalse);
      expect(missing.text, '');
      expect(''.isNullOrEmpty, isTrue);
      expect('a'.isNotNullOrEmpty, isTrue);
      expect('a'.text, 'a');
    });

    test('toDoubleValue / toIntValue comma to dot, empty to 0', () {
      String? missing;
      expect(missing.toDoubleValue, 0);
      expect(''.toDoubleValue, 0);
      expect('1,5'.toDoubleValue, 1.5);
      expect('2.25'.toDoubleValue, 2.25);
      expect('nope'.toDoubleValue, 0);
      expect(missing.toIntValue, 0);
      expect('42'.toIntValue, 42);
      expect('1.5'.toIntValue, 0);
    });
  });

  group('num?', () {
    test('isZero / isNotZero', () {
      num? missing;
      expect(missing.isZero, isTrue);
      expect(missing.isNotZero, isFalse);
      expect(0.isZero, isTrue);
      expect(0.0.isZero, isTrue);
      expect(3.isNotZero, isTrue);
    });
  });

  group('bool?', () {
    test('isTrue / isFalse treat null as false', () {
      bool? missing;
      expect(missing.isTrue, isFalse);
      expect(missing.isFalse, isTrue);
      expect(true.isTrue, isTrue);
      expect(true.isFalse, isFalse);
      expect(false.isTrue, isFalse);
      expect(false.isFalse, isTrue);
    });
  });

  group('List', () {
    test('nonNullsList drops nulls', () {
      expect([1, null, 2, null].nonNullsList, [1, 2]);
      expect(<String?>[].nonNullsList, <String>[]);
    });
  });

  group('DateTime', () {
    test('toDate strips time', () {
      final value = DateTime(2026, 9, 12, 15, 30, 45);
      expect(value.toDate, DateTime(2026, 9, 12));
    });
  });
}
