double? _asDouble(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value.toDouble();
  }

  if (value is double) {
    return value;
  }

  return double.tryParse(value.toString());
}

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic> json) mapper) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw
      .map((item) => mapper(Map<String, dynamic>.from(item as Map)))
      .toList();
}

class Routine {
  Routine({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String description;
  final List<RoutineExerciseTemplate> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      exercises: _mapList(json['exercises'], RoutineExerciseTemplate.fromJson),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class RoutineExerciseTemplate {
  RoutineExerciseTemplate({
    required this.id,
    required this.exerciseId,
    required this.order,
    required this.notes,
    required this.restSeconds,
    required this.sets,
  });

  final String id;
  final String exerciseId;
  final int order;
  final String notes;
  final int restSeconds;
  final List<RoutineTargetSet> sets;

  factory RoutineExerciseTemplate.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseTemplate(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      order: json['order'] as int,
      notes: json['notes'] as String? ?? '',
      restSeconds: json['restSeconds'] as int? ?? 0,
      sets: _mapList(json['sets'], RoutineTargetSet.fromJson),
    );
  }
}

class RoutineTargetSet {
  RoutineTargetSet({
    required this.id,
    required this.type,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.targetWeightKg,
  });

  final String id;
  final String type;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final double? targetWeightKg;

  factory RoutineTargetSet.fromJson(Map<String, dynamic> json) {
    return RoutineTargetSet(
      id: json['id'] as String,
      type: json['type'] as String,
      targetRepsMin: json['targetRepsMin'] as int?,
      targetRepsMax: json['targetRepsMax'] as int?,
      targetWeightKg: _asDouble(json['targetWeightKg']),
    );
  }
}
