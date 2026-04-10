List<String> _stringList(Object? value) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw.map((item) => item.toString()).toList();
}

class Exercise {
  Exercise({
    required this.id,
    required this.slug,
    required this.name,
    required this.category,
    required this.muscleGroups,
    required this.equipment,
    required this.instructions,
  });

  final String id;
  final String slug;
  final String name;
  final String category;
  final List<String> muscleGroups;
  final String equipment;
  final List<String> instructions;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      muscleGroups: _stringList(json['muscleGroups']),
      equipment: json['equipment'] as String,
      instructions: _stringList(json['instructions']),
    );
  }
}
