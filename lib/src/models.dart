class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredWeightUnit,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String preferredWeightUnit;
  final DateTime createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      preferredWeightUnit: json['preferredWeightUnit'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
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

class AnalyticsOverview {
  AnalyticsOverview({
    required this.totalSessions,
    required this.totalSets,
    required this.totalVolumeKg,
    required this.activeStreakDays,
    required this.favoriteExercises,
  });

  final int totalSessions;
  final int totalSets;
  final double totalVolumeKg;
  final int activeStreakDays;
  final List<FavoriteExercise> favoriteExercises;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverview(
      totalSessions: json['totalSessions'] as int? ?? 0,
      totalSets: json['totalSets'] as int? ?? 0,
      totalVolumeKg: _asDouble(json['totalVolumeKg']) ?? 0,
      activeStreakDays: json['activeStreakDays'] as int? ?? 0,
      favoriteExercises: _mapList(json['favoriteExercises'], FavoriteExercise.fromJson),
    );
  }
}

class FavoriteExercise {
  FavoriteExercise({
    required this.exerciseId,
    required this.name,
    required this.loggedSets,
  });

  final String exerciseId;
  final String name;
  final int loggedSets;

  factory FavoriteExercise.fromJson(Map<String, dynamic> json) {
    return FavoriteExercise(
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      loggedSets: json['loggedSets'] as int? ?? 0,
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

List<String> _stringList(Object? value) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw.map((item) => item.toString()).toList();
}

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic> json) mapper) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw
      .map((item) => mapper(Map<String, dynamic>.from(item as Map)))
      .toList();
}
