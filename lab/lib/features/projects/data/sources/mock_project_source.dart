import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../domain/project_model.dart';
import '../project_repository.dart';

/// In-memory projects — default mock backend.
class MockProjectSource implements ProjectSource {
  MockProjectSource({List<ProjectModel>? seed}) {
    _store.addAll(
      seed ??
          [
            ProjectModel(
              id: 'p1',
              name: 'Lemsa kits',
              budget: 1200,
              dueDate: DateTime(2026, 10, 1),
            ),
            ProjectModel(
              id: 'p2',
              name: 'Lab showcase',
              budget: 800,
              dueDate: DateTime(2026, 9, 20),
            ),
            for (var i = 3; i <= 25; i++)
              ProjectModel(
                id: 'p$i',
                name: 'Project $i',
                budget: i * 50,
              ),
          ],
    );
  }

  final List<ProjectModel> _store = [];

  @override
  Future<PagedResult<ProjectModel>> fetch(ProjectQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final q = query.search.trim().toLowerCase();
    final filtered = q.isEmpty
        ? List<ProjectModel>.of(_store)
        : _store
            .where((p) => p.name.toLowerCase().contains(q))
            .toList(growable: false);
    final start = (query.page - 1) * query.pageSize;
    if (start >= filtered.length) {
      return const PagedResult(items: [], hasMore: false);
    }
    final end = (start + query.pageSize).clamp(0, filtered.length);
    return PagedResult(
      items: filtered.sublist(start, end),
      hasMore: end < filtered.length,
    );
  }

  @override
  Future<ProjectModel> create(ProjectDraft draft) async {
    final project = ProjectModel(
      id: 'p-${DateTime.now().microsecondsSinceEpoch}',
      name: draft.name.trim(),
      budget: draft.budget,
      dueDate: draft.dueDate,
    );
    _store.insert(0, project);
    return project;
  }

  @override
  Future<ProjectModel> update(ProjectModel project) async {
    final i = _store.indexWhere((p) => p.id == project.id);
    if (i < 0) {
      throw const NotFoundFailure('project');
    }
    _store[i] = project;
    return project;
  }

  @override
  Future<void> delete(String id) async {
    _store.removeWhere((p) => p.id == id);
  }
}
