import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../app_controller.dart';
import '../../data/models/workout_session.dart';
import '../widgets/empty_state.dart';
import '../widgets/info_pill.dart';
import '../widgets/set_table.dart';

class ActiveWorkoutTab extends StatefulWidget {
  const ActiveWorkoutTab({
    super.key,
    required this.controller,
    required this.onCompleteWorkout,
    required this.onOpenRoutines,
  });

  final AppController controller;
  final Future<void> Function() onCompleteWorkout;
  final VoidCallback onOpenRoutines;

  @override
  State<ActiveWorkoutTab> createState() => _ActiveWorkoutTabState();
}

class _ActiveWorkoutTabState extends State<ActiveWorkoutTab> {
  bool _isReorderMode = false;

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {});
      _startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.controller.activeWorkout;

    if (workout == null) {
      return EmptyState(
        title: 'No active workout',
        description: 'Start a workout from the routines tab to begin logging sets.',
        actionLabel: 'Browse routines',
        onPressed: widget.onOpenRoutines,
      );
    }

    final completedSets = workout.exercises
        .expand<WorkoutSet>((exercise) => exercise.sets)
        .where((set) => set.isComplete)
        .length;
    final openSets = workout.exercises
        .expand<WorkoutSet>((exercise) => exercise.sets)
        .where((set) => !set.isComplete)
        .length;
    final emptyExercises = workout.exercises
        .where((exercise) => exercise.sets.every((set) => !set.isComplete))
        .length;
    final canComplete = workout.exercises.isNotEmpty && openSets == 0 && emptyExercises == 0;

    return Column(
      children: [
        if (_isReorderMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFF1F2937),
            child: Row(
              children: [
                const Text(
                  'Drag to reorder exercises',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _isReorderMode = false),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Color(0xFF60A5FA)),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
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
                      'Started ${formatDateTime(workout.startedAt)} - ${formatDuration(workout.elapsed)}',
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
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: widget.controller.isMutatingWorkout || !canComplete
                                ? null
                                : widget.onCompleteWorkout,
                            icon: const Icon(Icons.check_circle_outline_rounded),
                            label: const Text('Complete workout'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => setState(() => _isReorderMode = true),
                          tooltip: 'Reorder exercises',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withAlpha(25),
                          ),
                          icon: const Icon(Icons.reorder_rounded, color: Colors.white),
                        ),
                      ],
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
                            InfoPill(label: '$openSets open sets'),
                            InfoPill(label: '$emptyExercises empty exercises'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (_isReorderMode)
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workout.exercises.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    widget.controller.reorderExercise(oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final exercise = workout.exercises[index];
                    return _MinimizedExerciseCard(
                      key: ValueKey(exercise.id),
                      exercise: exercise,
                      exerciseName: widget.controller.exerciseName(exercise.exerciseId),
                      index: index,
                    );
                  },
                )
              else
                ...workout.exercises.map<Widget>(
                  (exercise) {
                    return Card(
                      key: ValueKey(exercise.id),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.drag_handle_rounded,
                                    color: Color(0xFFB0A898),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.controller.exerciseName(exercise.exerciseId),
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
                              ],
                            ),
                            const SizedBox(height: 16),
                            SetTable(
                              exercise: exercise,
                              isMutating: widget.controller.isMutatingWorkout,
                              onAddSet: () => widget.controller.addSet(exercise),
                              onLogSet: (weightKg, reps, set) =>
                                  widget.controller.logSet(
                                    exercise: exercise,
                                    set: set,
                                    reps: reps,
                                    weightKg: weightKg,
                                  ),
                              onToggleSet: (set) =>
                                  widget.controller.toggleSetComplete(
                                    exercise: exercise,
                                    set: set,
                                  ),
                              onCycleSetType: (type, set) =>
                                  widget.controller.cycleSetType(
                                    exercise: exercise,
                                    set: set,
                                    newType: type,
                                  ),
                              onRemoveSet: (set) =>
                                  widget.controller.removeSet(
                                    exercise: exercise,
                                    set: set,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MinimizedExerciseCard extends StatelessWidget {
  const _MinimizedExerciseCard({
    super.key,
    required this.exercise,
    required this.exerciseName,
    required this.index,
  });

  final WorkoutExercise exercise;
  final String exerciseName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D9C8)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6C655D),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              exerciseName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.drag_handle_rounded,
            color: Color(0xFFB0A898),
          ),
        ],
      ),
    );
  }
}
