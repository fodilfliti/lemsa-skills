enum TaskStatus { pending, done }

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    this.status = TaskStatus.pending,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] == 'done' ? TaskStatus.done : TaskStatus.pending,
    );
  }

  final String id;
  final String title;
  final TaskStatus status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status == TaskStatus.done ? 'done' : 'pending',
      };

  TaskModel copyWith({String? id, String? title, TaskStatus? status}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}
