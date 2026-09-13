import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/label_repository.dart';
import '../domain/label_model.dart';

final labelSourceProvider = Provider<LabelSource>((ref) => MockLabelSource());

final labelRepositoryProvider = Provider<LabelRepository>((ref) {
  return LabelRepositoryImpl(ref.watch(labelSourceProvider));
});

final labelListProvider =
    AsyncNotifierProvider<LabelListNotifier, PagedState<LabelModel>>(
  LabelListNotifier.new,
);

class LabelListNotifier extends AsyncNotifier<PagedState<LabelModel>>
    with PagedList<LabelModel, LabelQuery> {
  @override
  PagedSource<LabelModel, LabelQuery> get source =>
      ref.watch(labelSourceProvider);

  @override
  LabelQuery get initialQuery => const LabelQuery();

  @override
  LabelQuery queryWithPage(LabelQuery query, int page) =>
      LabelQuery(page: page, pageSize: query.pageSize);

  @override
  Future<PagedState<LabelModel>> build() => fetchFirstPage();
}
