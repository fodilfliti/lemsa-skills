import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_inbox_source.dart';
import '../domain/inbox_item.dart';

final inboxSourceProvider = Provider<InboxSource>((ref) => MockInboxSource());

final inboxListProvider =
    AsyncNotifierProvider<InboxListNotifier, PagedState<InboxItem>>(
  InboxListNotifier.new,
);

class InboxListNotifier extends AsyncNotifier<PagedState<InboxItem>>
    with PagedList<InboxItem, InboxQuery> {
  @override
  PagedSource<InboxItem, InboxQuery> get source =>
      ref.watch(inboxSourceProvider);

  @override
  InboxQuery get initialQuery => const InboxQuery();

  @override
  InboxQuery queryWithPage(InboxQuery query, int page) =>
      InboxQuery(page: page, pageSize: query.pageSize);

  @override
  Future<PagedState<InboxItem>> build() => fetchFirstPage();

  Future<void> markRead(InboxItem item) async {
    final updated = await ref.read(inboxSourceProvider).markRead(item.id);
    if (updated.id.isNotEmpty) {
      upsert(updated);
    }
  }
}
