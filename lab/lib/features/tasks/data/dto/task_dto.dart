class TaskDto {
  const TaskDto({
    required this.id,
    required this.title,
    required this.status,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
    );
  }

  final String id;
  final String title;
  final String status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
      };
}
