class WorkoutSession {
  WorkoutSession({
    required this.id,
    required this.userId,
    required this.routineId,
    required this.name,
    required this.notes,
    required this.status,
    required this.startedAt,
    required this.completedAt,
    required this.exercises,
  });

  final String id;
  final String userId;
  final String? routineId;
  final String name;
  final String notes;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<WorkoutExercise> exercises;

  bool get isActive => status == 'active';

  Duration get elapsed {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routineId: json['routineId'] as String?,
      name: json['name'] as String,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      exercises: _mapList(json['exercises'], WorkoutExercise.fromJson),
    );
  }
}

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic> json) mapper) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw
      .map((item) => mapper(Map<String, dynamic>.from(item as Map)))
      .toList();
}

class WorkoutExercise {
  WorkoutExercise({
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
  final List<WorkoutSet> sets;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      order: json['order'] as int,
      notes: json['notes'] as String? ?? '',
      restSeconds: json['restSeconds'] as int? ?? 0,
      sets: _mapList(json['sets'], WorkoutSet.fromJson),
    );
  }
}

class WorkoutSet {
  WorkoutSet({
    required this.id,
    required this.type,
    required this.reps,
    required this.weightKg,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.rir,
    required this.isComplete,
    required this.createdAt,
    required this.completedAt,
  });

  final String id;
  final String type;
  final int? reps;
  final double? weightKg;
  final int? durationSeconds;
  final double? distanceMeters;
  final int? rir;
  final bool isComplete;
  final DateTime createdAt;
  final DateTime? completedAt;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as String,
      type: json['type'] as String,
      reps: json['reps'] as int?,
      weightKg: _asDouble(json['weightKg']),
      durationSeconds: json['durationSeconds'] as int?,
      distanceMeters: _asDouble(json['distanceMeters']),
      rir: json['rir'] as int?,
      isComplete: json['isComplete'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }
}

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
