/// Manual backend switch for the lab showcase (T22).
///
/// Selection order:
/// 1. `--dart-define=LAB_BACKEND=mock|rest|supabase|firebase`
/// 2. Else default `mock` (matches `lemsa.yaml`).
///
/// Pages/controllers never import this for vendor types — only DI does.
enum LabBackend {
  mock,
  rest,
  supabase,
  firebase;

  static const _envKey = 'LAB_BACKEND';

  /// Resolved at compile time from dart-define; defaults to [mock].
  static LabBackend get current {
    const raw = String.fromEnvironment(_envKey, defaultValue: 'mock');
    return parse(raw);
  }

  static LabBackend parse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'rest':
      case 'dio':
      case 'retrofit':
        return LabBackend.rest;
      case 'supabase':
        return LabBackend.supabase;
      case 'firebase':
        return LabBackend.firebase;
      case 'mock':
      default:
        return LabBackend.mock;
    }
  }

  bool get needsSecrets =>
      this == LabBackend.supabase || this == LabBackend.firebase;
}
