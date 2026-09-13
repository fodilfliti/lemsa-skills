import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../domain/label_model.dart';

abstract interface class LabelSource
    implements PagedSource<LabelModel, LabelQuery> {
  Future<LabelModel> create(LabelDraft draft);
}

abstract interface class LabelRepository {
  Future<PagedResult<LabelModel>> fetch(LabelQuery query);

  Future<LabelModel> create(LabelDraft draft);
}

class LabelRepositoryImpl implements LabelRepository {
  LabelRepositoryImpl(this._source);

  final LabelSource _source;

  @override
  Future<PagedResult<LabelModel>> fetch(LabelQuery query) =>
      _source.fetch(query);

  @override
  Future<LabelModel> create(LabelDraft draft) {
    if (draft.name.trim().isEmpty) {
      throw const ValidationFailure({'name': 'required'});
    }
    return _source.create(draft);
  }
}

class MockLabelSource implements LabelSource {
  MockLabelSource() {
    _store.addAll(const [
      LabelModel(id: 'l1', name: 'Bug', colorHex: '#C0392B'),
      LabelModel(id: 'l2', name: 'Feature', colorHex: '#27AE60'),
      LabelModel(id: 'l3', name: 'Docs', colorHex: '#2980B9'),
      LabelModel(id: 'l4', name: 'Infra', colorHex: '#8E44AD'),
    ]);
  }

  final List<LabelModel> _store = [];

  @override
  Future<PagedResult<LabelModel>> fetch(LabelQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final start = (query.page - 1) * query.pageSize;
    if (start >= _store.length) {
      return const PagedResult(items: [], hasMore: false);
    }
    final end = (start + query.pageSize).clamp(0, _store.length);
    return PagedResult(
      items: _store.sublist(start, end),
      hasMore: end < _store.length,
    );
  }

  @override
  Future<LabelModel> create(LabelDraft draft) async {
    final label = LabelModel(
      id: 'l-${DateTime.now().microsecondsSinceEpoch}',
      name: draft.name.trim(),
      colorHex: draft.colorHex,
    );
    _store.insert(0, label);
    return label;
  }
}
