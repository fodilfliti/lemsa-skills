import 'package:flutter_data_kit/flutter_data_kit.dart';

/// Work area that groups tasks (portfolio multi-model demo).
class ProjectModel implements Identifiable {
  const ProjectModel({
    required this.id,
    required this.name,
    this.budget = 0,
    this.dueDate,
  });

  @override
  final String id;
  final String name;
  final num budget;
  final DateTime? dueDate;

  ProjectModel copyWith({
    String? id,
    String? name,
    num? budget,
    DateTime? dueDate,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      budget: budget ?? this.budget,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

class ProjectDraft {
  const ProjectDraft({
    required this.name,
    this.budget = 0,
    this.dueDate,
  });

  final String name;
  final num budget;
  final DateTime? dueDate;
}

class ProjectQuery extends PagedQuery {
  const ProjectQuery({
    super.page,
    super.pageSize = 10,
    this.search = '',
  });

  final String search;
}
