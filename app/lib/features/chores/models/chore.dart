class Chore {
  Chore({required this.id, required this.title, required this.points, required this.status});

  final String id;
  final String title;
  final int points;
  String status; // todo | in_progress | done

  Map<String, dynamic> toJson() => {
        'title': title,
        'points': points,
        'status': status,
      };

  factory Chore.fromJson(String id, Map<String, dynamic> json) => Chore(
        id: id,
        title: json['title'] as String,
        points: json['points'] as int,
        status: json['status'] as String,
      );
}
