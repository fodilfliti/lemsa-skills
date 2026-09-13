import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

import '../../../core/failures/failure_text.dart';
import '../../../i18n/strings.g.dart';
import '../state/inbox_providers.dart';

@RoutePage()
class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(inboxListProvider);
    final notifier = ref.read(inboxListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.inbox.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.refresh,
          ),
        ],
      ),
      body: AsyncView(
        value: async,
        error: (f) => Center(child: Text(failureText(f))),
        data: (state) {
          if (state.items.isEmpty) {
            return Center(child: Text(t.inbox.empty));
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return Center(
                  child: TextButton(
                    onPressed: notifier.loadMore,
                    child: Text(t.inbox.loadMore),
                  ),
                );
              }
              final item = state.items[index];
              return ListTile(
                leading: Icon(
                  item.read ? Icons.mark_email_read : Icons.mark_email_unread,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: item.read ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                subtitle: Text(item.body),
                onTap: item.read ? null : () => notifier.markRead(item),
              );
            },
          );
        },
      ),
    );
  }
}
