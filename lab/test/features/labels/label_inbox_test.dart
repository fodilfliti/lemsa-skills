import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/features/labels/data/label_repository.dart';
import 'package:lemsa_lab/features/labels/domain/label_model.dart';
import 'package:lemsa_lab/features/inbox/data/mock_inbox_source.dart';
import 'package:lemsa_lab/features/inbox/domain/inbox_item.dart';

void main() {
  test('LabelRepository create + page', () async {
    final repo = LabelRepositoryImpl(MockLabelSource());
    final page = await repo.fetch(const LabelQuery());
    expect(page.items, isNotEmpty);
    final created = await repo.create(const LabelDraft(name: 'Hotfix'));
    expect(created.name, 'Hotfix');
  });

  test('InboxSource pages + markRead', () async {
    final source = MockInboxSource();
    final page = await source.fetch(const InboxQuery(pageSize: 5));
    expect(page.items.length, 5);
    expect(page.hasMore, isTrue);
    final unread = page.items.firstWhere((e) => !e.read);
    final updated = await source.markRead(unread.id);
    expect(updated.read, isTrue);
  });
}
