// Pure field validators. Stub until flutter_input_kit ships.
// Returns an error code, never a translated string. No BuildContext, no slang.

typedef FieldValidator = String? Function(String value);

abstract final class Validators {
  static String? required(String v) => v.trim().isEmpty ? 'required' : null;

  static FieldValidator minLength(int n) =>
      (v) => v.trim().length < n ? 'minLength' : null;

  static final RegExp _email = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  static String? email(String v) {
    final trimmed = v.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return _email.hasMatch(trimmed) ? null : 'email';
  }

  /// First failure wins.
  static String? all(String v, List<FieldValidator> rules) {
    for (final rule in rules) {
      final error = rule(v);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
