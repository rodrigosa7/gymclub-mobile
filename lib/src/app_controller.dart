import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'models.dart';

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

  Future<void> logSet({
    required WorkoutExercise exercise,
    WorkoutSet? set,
    required int? reps,
    required double? weightKg,
    int? rir,
  }) async {
    final workout = activeWorkout;

    if (workout == null) {
      throw StateError('No active workout.');
    }

    await _runWorkoutMutation(() async {
      if (set != null && !set.isComplete) {
        activeWorkout = await api.updateWorkoutSet(
          workoutId: workout.id,
          workoutExerciseId: exercise.id,
          setId: set.id,
          reps: reps,
          weightKg: weightKg,
          rir: rir,
        );
      } else {
        activeWorkout = await api.addWorkoutSet(
          workoutId: workout.id,
          workoutExerciseId: exercise.id,
          reps: reps,
          weightKg: weightKg,
          rir: rir,
        );
      }

      errorMessage = null;
    });
  }

  Future<void> completeActiveWorkout() async {
    final workout = activeWorkout;

    if (workout == null) {
      throw StateError('No active workout.');
    }

    await _runWorkoutMutation(() async {
      await api.completeWorkout(workout.id);
      activeWorkout = null;
      history = await api.fetchHistory();
      analytics = await api.fetchAnalyticsOverview();
      errorMessage = null;
    });
  }

  Future<void> removeSet({
    required WorkoutExercise exercise,
    required WorkoutSet set,
  }) async {
    final workout = activeWorkout;

    if (workout == null) {
      throw StateError('No active workout.');
    }

    await _runWorkoutMutation(() async {
      activeWorkout = await api.removeWorkoutSet(
        workoutId: workout.id,
        workoutExerciseId: exercise.id,
        setId: set.id,
      );
      errorMessage = null;
    });
  }

  Future<void> removeExercise(WorkoutExercise exercise) async {
    final workout = activeWorkout;

    if (workout == null) {
      throw StateError('No active workout.');
    }

    await _runWorkoutMutation(() async {
      activeWorkout = await api.removeWorkoutExercise(
        workoutId: workout.id,
        workoutExerciseId: exercise.id,
      );
      errorMessage = null;
    });
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
