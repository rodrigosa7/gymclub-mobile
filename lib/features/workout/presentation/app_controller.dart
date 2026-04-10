import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';
import '../data/models/exercise.dart';
import '../data/models/routine.dart';
import '../data/models/workout_session.dart';
import '../data/models/analytics_overview.dart';
import '../../../core/api/gymclub_api_client.dart';

class AppController extends ChangeNotifier {
  AppController({required this.api});

  final GymClubApiClient api;

  bool isBootstrapping = true;
  bool isRefreshing = false;
  bool isMutatingWorkout = false;
  String? errorMessage;

  UserProfile? currentUser;
  List<Exercise> exercises = <Exercise>[];
  List<Routine> routines = <Routine>[];
  WorkoutSession? activeWorkout;
  List<WorkoutSession> history = <WorkoutSession>[];
  AnalyticsOverview? analytics;

  String exerciseSearch = '';

  List<Exercise> get filteredExercises {
    final query = exerciseSearch.trim().toLowerCase();

    if (query.isEmpty) {
      return exercises;
    }

    return exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query) ||
          exercise.muscleGroups.any((group) => group.toLowerCase().contains(query)) ||
          exercise.equipment.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> initialize() async {
    isBootstrapping = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<Object?>(<Future<Object?>>[
        api.fetchCurrentUser(),
        api.fetchExercises(),
        api.fetchRoutines(),
        api.fetchActiveWorkout(),
        api.fetchHistory(),
        api.fetchAnalyticsOverview(),
      ]);

      currentUser = results[0] as UserProfile;
      exercises = results[1] as List<Exercise>;
      routines = results[2] as List<Routine>;
      activeWorkout = results[3] as WorkoutSession?;
      history = results[4] as List<WorkoutSession>;
      analytics = results[5] as AnalyticsOverview;
    } catch (error) {
      errorMessage = _describeError(error);
    } finally {
      isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    isRefreshing = true;
    notifyListeners();

    try {
      final results = await Future.wait<Object?>(<Future<Object?>>[
        api.fetchExercises(),
        api.fetchRoutines(),
        api.fetchActiveWorkout(),
        api.fetchHistory(),
        api.fetchAnalyticsOverview(),
      ]);

      exercises = results[0] as List<Exercise>;
      routines = results[1] as List<Routine>;
      activeWorkout = results[2] as WorkoutSession?;
      history = results[3] as List<WorkoutSession>;
      analytics = results[4] as AnalyticsOverview;
      errorMessage = null;
    } catch (error) {
      errorMessage = _describeError(error);
      rethrow;
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> startWorkoutFromRoutine(String routineId) async {
    await _runWorkoutMutation(() async {
      activeWorkout = await api.startWorkoutFromRoutine(routineId);
      errorMessage = null;
    });
  }

  int _localSetCounter = 0;
  String _nextLocalSetId() => 'local_${++_localSetCounter}';

  // --- Local-only set mutations ---

  void addSet(WorkoutExercise exercise) {
    final workout = activeWorkout;
    if (workout == null) return;

    final newSet = WorkoutSet(
      id: _nextLocalSetId(),
      type: 'working',
      reps: null,
      weightKg: null,
      durationSeconds: null,
      distanceMeters: null,
      rir: null,
      isComplete: false,
      createdAt: DateTime.now(),
      completedAt: null,
    );

    activeWorkout = _copyWorkoutWithModifiedExercise(workout, exercise.id, (ex) {
      return WorkoutExercise(
        id: ex.id,
        exerciseId: ex.exerciseId,
        order: ex.order,
        notes: ex.notes,
        restSeconds: ex.restSeconds,
        sets: [...ex.sets, newSet],
      );
    });
    notifyListeners();
  }

  void logSet({
    required WorkoutExercise exercise,
    required WorkoutSet set,
    required int? reps,
    required double? weightKg,
    int? rir,
  }) {
    final workout = activeWorkout;
    if (workout == null) return;

    activeWorkout = _copyWorkoutWithModifiedExercise(workout, exercise.id, (ex) {
      return WorkoutExercise(
        id: ex.id,
        exerciseId: ex.exerciseId,
        order: ex.order,
        notes: ex.notes,
        restSeconds: ex.restSeconds,
        sets: ex.sets.map((s) {
          if (s.id == set.id) {
            return WorkoutSet(
              id: s.id,
              type: s.type,
              reps: reps,
              weightKg: weightKg,
              durationSeconds: s.durationSeconds,
              distanceMeters: s.distanceMeters,
              rir: rir ?? s.rir,
              isComplete: reps != null || weightKg != null,
              createdAt: s.createdAt,
              completedAt: (reps != null || weightKg != null) ? DateTime.now() : s.completedAt,
            );
          }
          return s;
        }).toList(),
      );
    });
    notifyListeners();
  }

  void toggleSetComplete({
    required WorkoutExercise exercise,
    required WorkoutSet set,
  }) {
    final workout = activeWorkout;
    if (workout == null) return;

    activeWorkout = _copyWorkoutWithModifiedExercise(workout, exercise.id, (ex) {
      return WorkoutExercise(
        id: ex.id,
        exerciseId: ex.exerciseId,
        order: ex.order,
        notes: ex.notes,
        restSeconds: ex.restSeconds,
        sets: ex.sets.map((s) {
          if (s.id == set.id) {
            return WorkoutSet(
              id: s.id,
              type: s.type,
              reps: s.reps,
              weightKg: s.weightKg,
              durationSeconds: s.durationSeconds,
              distanceMeters: s.distanceMeters,
              rir: s.rir,
              isComplete: !s.isComplete,
              createdAt: s.createdAt,
              completedAt: !s.isComplete ? DateTime.now() : null,
            );
          }
          return s;
        }).toList(),
      );
    });
    notifyListeners();
  }

  void cycleSetType({
    required WorkoutExercise exercise,
    required WorkoutSet set,
    required String newType,
  }) {
    final workout = activeWorkout;
    if (workout == null) return;

    activeWorkout = _copyWorkoutWithModifiedExercise(workout, exercise.id, (ex) {
      return WorkoutExercise(
        id: ex.id,
        exerciseId: ex.exerciseId,
        order: ex.order,
        notes: ex.notes,
        restSeconds: ex.restSeconds,
        sets: ex.sets.map((s) {
          if (s.id == set.id) {
            return WorkoutSet(
              id: s.id,
              type: newType,
              reps: s.reps,
              weightKg: s.weightKg,
              durationSeconds: s.durationSeconds,
              distanceMeters: s.distanceMeters,
              rir: s.rir,
              isComplete: s.isComplete,
              createdAt: s.createdAt,
              completedAt: s.completedAt,
            );
          }
          return s;
        }).toList(),
      );
    });
    notifyListeners();
  }

  void removeSet({
    required WorkoutExercise exercise,
    required WorkoutSet set,
  }) {
    final workout = activeWorkout;
    if (workout == null) return;

    activeWorkout = _copyWorkoutWithModifiedExercise(workout, exercise.id, (ex) {
      return WorkoutExercise(
        id: ex.id,
        exerciseId: ex.exerciseId,
        order: ex.order,
        notes: ex.notes,
        restSeconds: ex.restSeconds,
        sets: ex.sets.where((s) => s.id != set.id).toList(),
      );
    });
    notifyListeners();
  }

  void removeExercise(WorkoutExercise exercise) {
    final workout = activeWorkout;
    if (workout == null) return;

    activeWorkout = WorkoutSession(
      id: workout.id,
      userId: workout.userId,
      routineId: workout.routineId,
      name: workout.name,
      notes: workout.notes,
      status: workout.status,
      startedAt: workout.startedAt,
      completedAt: workout.completedAt,
      exercises: workout.exercises.where((ex) => ex.id != exercise.id).toList(),
    );
    notifyListeners();
  }

  void reorderExercise(int oldIndex, int newIndex) {
    final workout = activeWorkout;
    if (workout == null) return;

    final exercises = List<WorkoutExercise>.from(workout.exercises);
    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, item);

    // Update order field for each exercise
    final reorderedExercises = exercises.asMap().entries.map((entry) {
      return WorkoutExercise(
        id: entry.value.id,
        exerciseId: entry.value.exerciseId,
        order: entry.key + 1,
        notes: entry.value.notes,
        restSeconds: entry.value.restSeconds,
        sets: entry.value.sets,
      );
    }).toList();

    activeWorkout = WorkoutSession(
      id: workout.id,
      userId: workout.userId,
      routineId: workout.routineId,
      name: workout.name,
      notes: workout.notes,
      status: workout.status,
      startedAt: workout.startedAt,
      completedAt: workout.completedAt,
      exercises: reorderedExercises,
    );
    notifyListeners();
  }

  Future<void> completeActiveWorkout() async {
    final workout = activeWorkout;
    if (workout == null) return;

    isMutatingWorkout = true;
    notifyListeners();

    try {
      final exercisePayloads = workout.exercises.map((ex) {
        return <String, dynamic>{
          'id': ex.id,
          'exerciseId': ex.exerciseId,
          'notes': ex.notes,
          'restSeconds': ex.restSeconds,
          'sets': ex.sets.map((s) {
            return <String, dynamic>{
              'id': s.id.startsWith('local_') ? null : s.id,
              'type': s.type,
              'reps': s.reps,
              'weightKg': s.weightKg,
              'durationSeconds': s.durationSeconds,
              'distanceMeters': s.distanceMeters,
              'rir': s.rir,
              'isComplete': s.isComplete,
            };
          }).toList(),
        };
      }).toList();

      await api.syncWorkout(
        workoutId: workout.id,
        name: workout.name,
        notes: workout.notes,
        exercises: exercisePayloads,
      );

      activeWorkout = null;
      final results = await Future.wait<Object?>(<Future<Object?>>[
        api.fetchHistory(),
        api.fetchAnalyticsOverview(),
      ]);
      history = results[0] as List<WorkoutSession>;
      analytics = results[1] as AnalyticsOverview;
      errorMessage = null;
    } catch (error) {
      errorMessage = _describeError(error);
      rethrow;
    } finally {
      isMutatingWorkout = false;
      notifyListeners();
    }
  }

  WorkoutSession _copyWorkoutWithModifiedExercise(
    WorkoutSession workout,
    String exerciseId,
    WorkoutExercise Function(WorkoutExercise) transform,
  ) {
    return WorkoutSession(
      id: workout.id,
      userId: workout.userId,
      routineId: workout.routineId,
      name: workout.name,
      notes: workout.notes,
      status: workout.status,
      startedAt: workout.startedAt,
      completedAt: workout.completedAt,
      exercises: workout.exercises.map((ex) {
        if (ex.id == exerciseId) {
          return transform(ex);
        }
        return ex;
      }).toList(),
    );
  }

  void updateExerciseSearch(String value) {
    exerciseSearch = value;
    notifyListeners();
  }

  String exerciseName(String exerciseId) {
    for (final exercise in exercises) {
      if (exercise.id == exerciseId) {
        return exercise.name;
      }
    }

    return exerciseId;
  }

  Future<void> _runWorkoutMutation(Future<void> Function() action) async {
    isMutatingWorkout = true;
    notifyListeners();

    try {
      await action();
    } finally {
      isMutatingWorkout = false;
      notifyListeners();
    }
  }

  String _describeError(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Something went wrong while talking to the backend.';
  }

  @override
  void dispose() {
    api.dispose();
    super.dispose();
  }
}
