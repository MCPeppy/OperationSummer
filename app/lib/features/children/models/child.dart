class Child {
  Child({required this.id, required this.name, this.points = 0});

  final String id;
  final String name;
  int points;

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points,
      };

  factory Child.fromJson(String id, Map<String, dynamic> json) => Child(
        id: id,
        name: json['name'] as String,
        points: (json['points'] ?? 0) as int,
      );
}
