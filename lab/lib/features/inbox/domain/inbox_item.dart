import 'package:flutter_data_kit/flutter_data_kit.dart';

/// Inbox / comment-style notification for the portfolio domain.
class InboxItem implements Identifiable {
  const InboxItem({
    required this.id,
    required this.title,
    required this.body,
    this.read = false,
  });

  @override
  final String id;
  final String title;
  final String body;
  final bool read;

  InboxItem copyWith({
    String? id,
    String? title,
    String? body,
    bool? read,
  }) {
    return InboxItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      read: read ?? this.read,
    );
  }
}

class InboxQuery extends PagedQuery {
  const InboxQuery({super.page, super.pageSize = 15});
}
