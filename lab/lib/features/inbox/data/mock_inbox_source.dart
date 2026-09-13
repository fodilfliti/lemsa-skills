import 'package:flutter_data_kit/flutter_data_kit.dart';

import '../domain/inbox_item.dart';

abstract interface class InboxSource
    implements PagedSource<InboxItem, InboxQuery> {
  Future<InboxItem> markRead(String id);
}

class MockInboxSource implements InboxSource {
  MockInboxSource() {
    _store.addAll([
      const InboxItem(
        id: 'i1',
        title: 'Welcome',
        body: 'Lab showcase is ready — explore projects and labels.',
      ),
      const InboxItem(
        id: 'i2',
        title: 'Backend tip',
        body: 'Switch LAB_BACKEND via dart-define (see README).',
        read: true,
      ),
      for (var i = 3; i <= 18; i++)
        InboxItem(
          id: 'i$i',
          title: 'Update $i',
          body: 'Comment-style inbox row $i',
          read: i.isEven,
        ),
    ]);
  }

  final List<InboxItem> _store = [];

  @override
  Future<PagedResult<InboxItem>> fetch(InboxQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
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
  Future<InboxItem> markRead(String id) async {
    final i = _store.indexWhere((e) => e.id == id);
    if (i < 0) {
      return const InboxItem(id: '', title: '', body: '');
    }
    final next = _store[i].copyWith(read: true);
    _store[i] = next;
    return next;
  }
}
