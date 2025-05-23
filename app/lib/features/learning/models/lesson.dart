class Lesson {
  Lesson({required this.id, required this.title, required this.date, this.attachmentPath});

  final String id;
  final String title;
  final DateTime date;
  final String? attachmentPath;

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        if (attachmentPath != null) 'attachmentPath': attachmentPath,
      };

  factory Lesson.fromJson(String id, Map<String, dynamic> json) => Lesson(
        id: id,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        attachmentPath: json['attachmentPath'] as String?,
      );
}
