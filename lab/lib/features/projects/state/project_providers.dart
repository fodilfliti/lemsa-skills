import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/project_repository.dart';
import '../data/sources/mock_project_source.dart';
import '../domain/project_model.dart';

final projectSourceProvider = Provider<ProjectSource>((ref) {
  return MockProjectSource();
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl(ref.watch(projectSourceProvider));
});

final projectListProvider =
    AsyncNotifierProvider<ProjectListNotifier, PagedState<ProjectModel>>(
  ProjectListNotifier.new,
);

class ProjectListNotifier extends AsyncNotifier<PagedState<ProjectModel>>
    with PagedList<ProjectModel, ProjectQuery> {
  @override
  PagedSource<ProjectModel, ProjectQuery> get source =>
      ref.watch(projectSourceProvider);

  @override
  ProjectQuery get initialQuery => const ProjectQuery();

  @override
  ProjectQuery queryWithPage(ProjectQuery query, int page) {
    return ProjectQuery(
      page: page,
      pageSize: query.pageSize,
      search: query.search,
    );
  }

  @override
  Future<PagedState<ProjectModel>> build() => fetchFirstPage();
}
