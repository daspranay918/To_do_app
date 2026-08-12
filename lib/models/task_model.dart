class TaskModel {
  final String title;
  bool isCompleted;
  final DateTime? dateTime;

  TaskModel({required this.title, this.isCompleted = false, this.dateTime});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'dateTime': dateTime?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      dateTime: json['dateTime'] != null
          ? DateTime.tryParse(json['dateTime'] as String)
          : null,
    );
  }
}
