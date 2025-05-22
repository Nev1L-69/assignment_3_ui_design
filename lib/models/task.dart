class Task {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime created;
  final DateTime? completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    required this.created,
    this.completed,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? created,
    DateTime? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      created: created ?? this.created,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone,
    'created': created.toIso8601String(),
    'completed': completed?.toIso8601String(),
  };

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] ?? false,
      created: DateTime.parse(map['created']),
      completed:
          map['completed'] != null ? DateTime.parse(map['completed']) : null,
    );
  }
}
