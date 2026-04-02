import 'package:flutter/material.dart';

import 'api_client.dart';
import 'app_controller.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.apiBaseUrl,
  });

  final AppController controller;
  final String apiBaseUrl;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.isBootstrapping && widget.controller.currentUser == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (widget.controller.errorMessage != null && widget.controller.currentUser == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gym Club Test App')),
            body: _EmptyState(
              title: 'Backend connection failed',
              description: widget.controller.errorMessage!,
              actionLabel: 'Retry',
              onPressed: () {
                widget.controller.initialize();
              },
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_titleForIndex(_selectedIndex)),
            actions: <Widget>[
              if (widget.controller.isRefreshing || widget.controller.isMutatingWorkout)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _handleRefresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildBody(),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.repeat_outlined),
                selectedIcon: Icon(Icons.repeat_rounded),
                label: 'Routines',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Exercises',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'History',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardTab(
          key: const ValueKey<String>('dashboard'),
          controller: widget.controller,
          apiBaseUrl: widget.apiBaseUrl,
          onOpenWorkout: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          onOpenRoutines: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 1:
        return RoutinesTab(
          key: const ValueKey<String>('routines'),
          controller: widget.controller,
          onStartWorkout: _handleStartWorkout,
        );
      case 2:
        return ActiveWorkoutTab(
          key: const ValueKey<String>('workout'),
          controller: widget.controller,
          onLogSet: _handleLogSet,
          onRemoveSet: _handleRemoveSet,
          onRemoveExercise: _handleRemoveExercise,
          onCompleteWorkout: _handleCompleteWorkout,
          onOpenRoutines: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 3:
        return ExercisesTab(
          key: const ValueKey<String>('exercises'),
          controller: widget.controller,
        );
      case 4:
        return HistoryTab(
          key: const ValueKey<String>('history'),
          controller: widget.controller,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleRefresh() async {
    try {
      await widget.controller.refreshData();
      if (!mounted) {
        return;
      }

      _showSnack('Fresh data loaded from the backend.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleStartWorkout(String routineId) async {
    try {
      await widget.controller.startWorkoutFromRoutine(routineId);
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedIndex = 2;
      });
      _showSnack('Workout started.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      if (error is ApiException && error.statusCode == 409) {
        setState(() {
          _selectedIndex = 2;
        });
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleLogSet(WorkoutExercise exercise, WorkoutSet? set) async {
    final draft = await _showSetDialog(context, existingSet: set);

    if (draft == null) {
      return;
    }

    try {
      await widget.controller.logSet(
        exercise: exercise,
        set: set,
        reps: draft.reps,
        weightKg: draft.weightKg,
        rir: draft.rir,
      );
      if (!mounted) {
        return;
      }

      _showSnack(set == null ? 'Set added.' : 'Set logged.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleCompleteWorkout() async {
    try {
      await widget.controller.completeActiveWorkout();
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedIndex = 4;
      });
      _showSnack('Workout completed and moved into history.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleRemoveSet(WorkoutExercise exercise, WorkoutSet set) async {
    final confirmed = await _confirmAction(
      context,
      title: 'Remove set?',
      message: 'This set will be removed from the active workout.',
      confirmLabel: 'Remove',
    );

    if (confirmed != true) {
      return;
    }

    try {
      await widget.controller.removeSet(exercise: exercise, set: set);
      if (!mounted) {
        return;
      }

      _showSnack('Set removed.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleRemoveExercise(WorkoutExercise exercise) async {
    final confirmed = await _confirmAction(
      context,
      title: 'Remove exercise?',
      message: 'This exercise and all of its sets will be removed from the active workout.',
      confirmLabel: 'Remove',
    );

    if (confirmed != true) {
      return;
    }

    try {
      await widget.controller.removeExercise(exercise);
      if (!mounted) {
        return;
      }

      _showSnack('Exercise removed.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Gym Club Dashboard';
      case 1:
        return 'Routines';
      case 2:
        return 'Active Workout';
      case 3:
        return 'Exercise Library';
      case 4:
        return 'Workout History';
      default:
        return 'Gym Club';
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _messageForError(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    if (error is StateError) {
      return error.message.toString();
    }

    return 'Something went wrong while talking to the backend.';
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    required this.controller,
    required this.apiBaseUrl,
    required this.onOpenWorkout,
    required this.onOpenRoutines,
  });

  final AppController controller;
  final String apiBaseUrl;
  final VoidCallback onOpenWorkout;
  final VoidCallback onOpenRoutines;

  @override
  Widget build(BuildContext context) {
    final profile = controller.currentUser;
    final analytics = controller.analytics;
    final activeWorkout = controller.activeWorkout;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: <Color>[
                Color(0xFF2F4858),
                Color(0xFF5E7A72),
                Color(0xFFD97706),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                profile == null ? 'Ready to test' : 'Welcome back, ${profile.name}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'This Flutter client is wired to $apiBaseUrl and exercises the Hevy-style backend flows.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFF9EFE2),
                    ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: activeWorkout == null ? onOpenRoutines : onOpenWorkout,
                    icon: Icon(activeWorkout == null ? Icons.play_arrow_rounded : Icons.bolt_rounded),
                    label: Text(activeWorkout == null ? 'Start from routines' : 'Resume workout'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onOpenRoutines,
                    icon: const Icon(Icons.repeat_rounded),
                    label: const Text('Browse routines'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (analytics != null)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MetricCard(
                title: 'Sessions',
                value: analytics.totalSessions.toString(),
                caption: 'completed workouts',
                accent: const Color(0xFF335C67),
              ),
              _MetricCard(
                title: 'Sets',
                value: analytics.totalSets.toString(),
                caption: 'logged working volume',
                accent: const Color(0xFF9C6644),
              ),
              _MetricCard(
                title: 'Volume',
                value: '${_formatDouble(analytics.totalVolumeKg)} kg',
                caption: 'total tracked load',
                accent: const Color(0xFF588157),
              ),
              _MetricCard(
                title: 'Streak',
                value: analytics.activeStreakDays.toString(),
                caption: 'consecutive days',
                accent: const Color(0xFFB56576),
              ),
            ],
          ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: activeWorkout == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'No active workout',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pick a routine to generate an active session with prebuilt exercises and sets.',
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: onOpenRoutines,
                        child: const Text('Open routines'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        activeWorkout.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${activeWorkout.exercises.length} exercises - started ${_formatDateTime(activeWorkout.startedAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF5E584F),
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: activeWorkout.exercises
                            .take(3)
                            .map(
                              (exercise) => Chip(
                                label: Text(controller.exerciseName(exercise.exerciseId)),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: onOpenWorkout,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Open active workout'),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class RoutinesTab extends StatelessWidget {
  const RoutinesTab({
    super.key,
    required this.controller,
    required this.onStartWorkout,
  });

  final AppController controller;
  final Future<void> Function(String routineId) onStartWorkout;

  @override
  Widget build(BuildContext context) {
    if (controller.routines.isEmpty) {
      return const _EmptyState(
        title: 'No routines yet',
        description: 'Create a routine from the backend API and it will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      itemCount: controller.routines.length,
      itemBuilder: (context, index) {
        final routine = controller.routines[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            routine.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            routine.description.isEmpty
                                ? 'No description provided.'
                                : routine.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: controller.isMutatingWorkout
                          ? null
                          : () => onStartWorkout(routine.id),
                      child: const Text('Start'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: routine.exercises
                      .map(
                        (exercise) => Chip(
                          avatar: const Icon(Icons.fitness_center, size: 18),
                          label: Text(controller.exerciseName(exercise.exerciseId)),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                ...routine.exercises.map(
                  (exercise) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2E3D4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text('${exercise.order}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                controller.exerciseName(exercise.exerciseId),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                '${exercise.sets.length} sets - ${exercise.restSeconds}s rest',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (exercise.notes.isNotEmpty)
                                Text(
                                  exercise.notes,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF6C655D),
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ActiveWorkoutTab extends StatelessWidget {
  const ActiveWorkoutTab({
    super.key,
    required this.controller,
    required this.onLogSet,
    required this.onRemoveSet,
    required this.onRemoveExercise,
    required this.onCompleteWorkout,
    required this.onOpenRoutines,
  });

  final AppController controller;
  final Future<void> Function(WorkoutExercise exercise, WorkoutSet? set) onLogSet;
  final Future<void> Function(WorkoutExercise exercise, WorkoutSet set) onRemoveSet;
  final Future<void> Function(WorkoutExercise exercise) onRemoveExercise;
  final Future<void> Function() onCompleteWorkout;
  final VoidCallback onOpenRoutines;

  @override
  Widget build(BuildContext context) {
    final workout = controller.activeWorkout;

    if (workout == null) {
      return _EmptyState(
        title: 'No active workout',
        description: 'Start a workout from the routines tab to begin logging sets.',
        actionLabel: 'Browse routines',
        onPressed: onOpenRoutines,
      );
    }

    final completedSets = workout.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.isComplete)
        .length;
    final openSets = workout.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => !set.isComplete)
        .length;
    final emptyExercises = workout.exercises
        .where((exercise) => exercise.sets.every((set) => !set.isComplete))
        .length;
    final canComplete = workout.exercises.isNotEmpty && openSets == 0 && emptyExercises == 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                workout.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${workout.exercises.length} exercises - $completedSets completed sets',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFD1D5DB),
                    ),
              ),
              const SizedBox(height: 14),
              Text(
                'Started ${_formatDateTime(workout.startedAt)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF9CA3AF),
                    ),
              ),
              if (workout.notes.isNotEmpty) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  workout.notes,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE5E7EB),
                      ),
                ),
              ],
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: controller.isMutatingWorkout || !canComplete ? null : onCompleteWorkout,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Complete workout'),
              ),
            ],
          ),
        ),
        if (!canComplete) ...<Widget>[
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Workout still has unfinished items',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log or remove every open set, and remove exercises with no logged sets before completing.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6C655D),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _InfoPill(label: '$openSets open sets'),
                      _InfoPill(label: '$emptyExercises empty exercises'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        ...workout.exercises.map(
          (exercise) => Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              controller.exerciseName(exercise.exerciseId),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${exercise.sets.length} sets - ${exercise.restSeconds}s rest',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (exercise.notes.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 6),
                              Text(
                                exercise.notes,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6C655D),
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: controller.isMutatingWorkout
                            ? null
                            : () => onRemoveExercise(exercise),
                        icon: const Icon(Icons.delete_outline_rounded),
                        tooltip: 'Remove exercise',
                      ),
                      IconButton(
                        onPressed: controller.isMutatingWorkout
                            ? null
                            : () => onLogSet(exercise, null),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        tooltip: 'Add set',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...exercise.sets.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _WorkoutSetTile(
                        index: entry.key + 1,
                        set: entry.value,
                        onLog: controller.isMutatingWorkout || entry.value.isComplete
                            ? null
                            : () => onLogSet(exercise, entry.value),
                        onRemove: controller.isMutatingWorkout
                            ? null
                            : () => onRemoveSet(exercise, entry.value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExercisesTab extends StatelessWidget {
  const ExercisesTab({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final exercises = controller.filteredExercises;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: TextField(
            onChanged: controller.updateExerciseSearch,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search by name, equipment, or muscle group',
            ),
          ),
        ),
        Expanded(
          child: exercises.isEmpty
              ? const _EmptyState(
                  title: 'No exercises match',
                  description: 'Try a broader search term.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                Chip(label: Text(_humanize(exercise.category))),
                                Chip(label: Text(_humanize(exercise.equipment))),
                                ...exercise.muscleGroups.map(
                                  (group) => Chip(label: Text(_humanize(group))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ...exercise.instructions.map(
                              (instruction) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Icon(Icons.circle, size: 7),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(instruction)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.history.isEmpty) {
      return const _EmptyState(
        title: 'No completed workouts yet',
        description: 'Once you finish an active workout it will show up here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      itemCount: controller.history.length,
      itemBuilder: (context, index) {
        final workout = controller.history[index];
        final completedSetCount = workout.exercises
            .expand((exercise) => exercise.sets)
            .where((set) => set.isComplete)
            .length;

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _showHistoryWorkoutDetails(context, controller, workout),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              workout.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Completed ${_formatDateTime(workout.completedAt ?? workout.startedAt)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6C655D),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _InfoPill(label: '${workout.exercises.length} exercises'),
                      _InfoPill(label: '$completedSetCount completed sets'),
                      if (workout.routineId != null) const _InfoPill(label: 'From routine'),
                    ],
                  ),
                  if (workout.notes.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(workout.notes),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    'Tap to inspect exercises and logged sets',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6C655D),
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutSetTile extends StatelessWidget {
  const _WorkoutSetTile({
    required this.index,
    required this.set,
    this.onLog,
    this.onRemove,
  });

  final int index;
  final WorkoutSet set;
  final VoidCallback? onLog;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final summary = _setSummary(set);
    final tone = set.isComplete ? const Color(0xFF1F7A4D) : const Color(0xFFB45309);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D9C8)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tone.withOpacity(0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text('$index'),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _humanize(set.type),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  summary,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6C655D),
                      ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (set.isComplete)
                Icon(Icons.check_circle_rounded, color: tone)
              else
                FilledButton.tonal(
                  onPressed: onLog,
                  child: const Text('Log'),
                ),
              if (onRemove != null) ...<Widget>[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove set',
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryExerciseSection extends StatelessWidget {
  const _HistoryExerciseSection({
    required this.controller,
    required this.exercise,
  });

  final AppController controller;
  final WorkoutExercise exercise;

  @override
  Widget build(BuildContext context) {
    final completedSets = exercise.sets.where((set) => set.isComplete).toList();
    final totalVolume = completedSets.fold<double>(
      0,
      (sum, set) => sum + ((set.reps ?? 0) * (set.weightKg ?? 0)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            controller.exerciseName(exercise.exerciseId),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _InfoPill(label: '${completedSets.length} completed sets'),
              _InfoPill(label: '${_formatDouble(totalVolume)} kg volume'),
              _InfoPill(label: '${exercise.restSeconds}s rest'),
            ],
          ),
          if (exercise.notes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              exercise.notes,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6C655D),
                  ),
            ),
          ],
          const SizedBox(height: 14),
          ...exercise.sets.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _WorkoutSetTile(
                index: entry.key + 1,
                set: entry.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.accent,
  });

  final String title;
  final String value;
  final String caption;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                caption,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6C655D),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E6D7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onPressed,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF2E3D4),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.sports_gymnastics_rounded, size: 34),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6C655D),
                  ),
            ),
            if (actionLabel != null && onPressed != null) ...<Widget>[
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _showHistoryWorkoutDetails(
  BuildContext context,
  AppController controller,
  WorkoutSession workout,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          final completedSetCount = workout.exercises
              .expand((exercise) => exercise.sets)
              .where((set) => set.isComplete)
              .length;
          final totalVolume = workout.exercises
              .expand((exercise) => exercise.sets)
              .where((set) => set.isComplete)
              .fold<double>(
                0,
                (sum, set) => sum + ((set.reps ?? 0) * (set.weightKg ?? 0)),
              );

          return Material(
            color: const Color(0xFFF7F1E8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: <Widget>[
                Center(
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7C1AA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  workout.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completed ${_formatDateTime(workout.completedAt ?? workout.startedAt)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6C655D),
                      ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _InfoPill(label: '${workout.exercises.length} exercises'),
                    _InfoPill(label: '$completedSetCount completed sets'),
                    _InfoPill(label: '${_formatDouble(totalVolume)} kg total volume'),
                  ],
                ),
                if (workout.notes.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    workout.notes,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 18),
                ...workout.exercises.map(
                  (exercise) => _HistoryExerciseSection(
                    controller: controller,
                    exercise: exercise,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<_SetDraft?> _showSetDialog(
  BuildContext context, {
  WorkoutSet? existingSet,
}) async {
  final repsController = TextEditingController(
    text: existingSet?.reps?.toString() ?? '',
  );
  final weightController = TextEditingController(
    text: existingSet?.weightKg == null ? '' : _formatDouble(existingSet!.weightKg!),
  );
  final rirController = TextEditingController(
    text: existingSet?.rir?.toString() ?? '',
  );

  try {
    return await showModalBottomSheet<_SetDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        existingSet == null ? 'Add set' : 'Log planned set',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: repsController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          hintText: '8',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          hintText: '70',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: rirController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'RIR (optional)',
                          hintText: '2',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                  _SetDraft(
                                    reps: int.tryParse(repsController.text.trim()),
                                    weightKg: double.tryParse(weightController.text.trim()),
                                    rir: int.tryParse(rirController.text.trim()),
                                  ),
                                );
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  } finally {
    repsController.dispose();
    weightController.dispose();
    rirController.dispose();
  }
}

Future<bool?> _confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
}

class _SetDraft {
  const _SetDraft({
    required this.reps,
    required this.weightKg,
    required this.rir,
  });

  final int? reps;
  final double? weightKg;
  final int? rir;
}

String _setSummary(WorkoutSet set) {
  final parts = <String>[];

  if (set.reps != null) {
    parts.add('${set.reps} reps');
  }

  if (set.weightKg != null) {
    parts.add('${_formatDouble(set.weightKg!)} kg');
  }

  if (set.rir != null) {
    parts.add('RIR ${set.rir}');
  }

  if (set.durationSeconds != null) {
    parts.add('${set.durationSeconds}s');
  }

  if (parts.isEmpty) {
    return set.isComplete ? 'Completed set' : 'Waiting to be logged';
  }

  return parts.join(' - ');
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][local.month - 1];

  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$month ${local.day}, ${local.year} - $hour:$minute';
}

String _formatDouble(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
}

String _humanize(String value) {
  return value
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
