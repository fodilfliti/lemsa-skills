import '../../i18n/strings.g.dart';

/// Map a field error **code** to slang at the render site.
///
/// Kits/validators never call `t.*`. Pass [n] for codes that interpolate
/// (stub: `minLength` — the real kit may carry args on the issue object).
String? fieldErrorText(String? code, {int? n}) => switch (code) {
      null => null,
      'required' => t.validation.required,
      'email' => t.validation.email,
      'minLength' => t.validation.minLength(n: n ?? 0),
      'passwordMismatch' => t.validation.passwordMismatch,
      'money' => t.validation.money,
      'form' => t.validation.form,
      _ => t.validation.form,
    };
