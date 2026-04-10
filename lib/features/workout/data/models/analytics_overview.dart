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

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic> json) mapper) {
  final raw = value as List<dynamic>? ?? <dynamic>[];
  return raw
      .map((item) => mapper(Map<String, dynamic>.from(item as Map)))
      .toList();
}
