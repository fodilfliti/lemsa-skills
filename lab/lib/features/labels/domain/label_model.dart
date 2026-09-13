import 'package:flutter_data_kit/flutter_data_kit.dart';

/// Tag applied to work items.
class LabelModel implements Identifiable {
  const LabelModel({
    required this.id,
    required this.name,
    this.colorHex = '#4A90A4',
  });

  @override
  final String id;
  final String name;
  final String colorHex;

  LabelModel copyWith({String? id, String? name, String? colorHex}) {
    return LabelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}

class LabelDraft {
  const LabelDraft({required this.name, this.colorHex = '#4A90A4'});

  final String name;
  final String colorHex;
}

class LabelQuery extends PagedQuery {
  const LabelQuery({super.page, super.pageSize = 20});
}
