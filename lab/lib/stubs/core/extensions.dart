// Pure Dart extensions. Stub until lemsa_core_kit ships.
// No BuildContext, Riverpod, or slang.

extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String get text => this ?? '';

  double get toDoubleValue {
    final raw = text.isNullOrEmpty ? '0' : text.replaceAll(',', '.');
    return double.tryParse(raw) ?? 0;
  }

  int get toIntValue {
    final raw = text.isNullOrEmpty ? '0' : text.replaceAll(',', '.');
    return int.tryParse(raw) ?? 0;
  }
}

extension NullableNumX on num? {
  bool get isZero => (this ?? 0) == 0;

  bool get isNotZero => !isZero;
}

extension NullableBoolX on bool? {
  bool get isTrue => this == true;

  /// `null` is treated as false, matching the Kiwash helper.
  bool get isFalse => this != true;
}

extension NullableListX<T> on List<T?> {
  List<T> get nonNullsList => whereType<T>().toList();
}

extension DateTimeX on DateTime {
  DateTime get toDate => DateTime(year, month, day);
}
