class TaskDraft {
  const TaskDraft({required this.title});

  final String title;

  TaskDraft copyWith({String? title}) => TaskDraft(title: title ?? this.title);
}
