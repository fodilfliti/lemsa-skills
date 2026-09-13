import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../domain/project_model.dart';

abstract interface class ProjectSource
    implements PagedSource<ProjectModel, ProjectQuery> {
  Future<ProjectModel> create(ProjectDraft draft);

  Future<ProjectModel> update(ProjectModel project);

  Future<void> delete(String id);
}

abstract interface class ProjectRepository {
  Future<PagedResult<ProjectModel>> fetch(ProjectQuery query);

  Future<ProjectModel> create(ProjectDraft draft);

  Future<ProjectModel> update(ProjectModel project);

  Future<void> delete(String id);
}

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(this._source);

  final ProjectSource _source;

  @override
  Future<PagedResult<ProjectModel>> fetch(ProjectQuery query) =>
      _source.fetch(query);

  @override
  Future<ProjectModel> create(ProjectDraft draft) {
    if (draft.name.trim().isEmpty) {
      throw const ValidationFailure({'name': 'required'});
    }
    return _source.create(draft);
  }

  @override
  Future<ProjectModel> update(ProjectModel project) => _source.update(project);

  @override
  Future<void> delete(String id) => _source.delete(id);
}
