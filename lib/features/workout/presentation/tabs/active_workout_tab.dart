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

class _ActiveWorkoutTabState extends State<ActiveWorkoutTab>
    with SingleTickerProviderStateMixin {
  bool _isReorderMode = false;
  int? _draggingIndex;

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

  void _onDragEnd(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    widget.controller.reorderExercise(oldIndex, newIndex);
    setState(() {
      _isReorderMode = false;
      _draggingIndex = null;
    });
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isReorderMode ? 52 : 0,
          child: _isReorderMode
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: const Color(0xFF1F2937),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.drag_indicator,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Drag to reorder, release to finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
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
                    FilledButton.icon(
                      onPressed: widget.controller.isMutatingWorkout || !canComplete
                          ? null
                          : widget.onCompleteWorkout,
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
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: workout.exercises.length,
                onReorder: _onDragEnd,
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final scale = Tween<double>(begin: 1.0, end: 1.05).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                      ).value;
                      return Transform.scale(
                        scale: scale,
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.transparent,
                          child: child,
                        ),
                      );
                    },
                  );
                },
                itemBuilder: (context, index) {
                  final exercise = workout.exercises[index];
                  return _ExerciseCard(
                    key: ValueKey(exercise.id),
                    exercise: exercise,
                    index: index,
                    controller: widget.controller,
                    isReorderMode: _isReorderMode,
                    isDragging: _draggingIndex == index,
                    onDragStart: () {
                      setState(() {
                        _isReorderMode = true;
                        _draggingIndex = index;
                      });
                    },
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

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.controller,
    required this.isReorderMode,
    required this.isDragging,
    required this.onDragStart,
  });

  final WorkoutExercise exercise;
  final int index;
  final AppController controller;
  final bool isReorderMode;
  final bool isDragging;
  final VoidCallback onDragStart;

  @override
  Widget build(BuildContext context) {
    final isMinimized = isReorderMode;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isMinimized
          ? _MinimizedExerciseCard(
              key: ValueKey('mini_${exercise.id}'),
              exerciseName: controller.exerciseName(exercise.exerciseId),
              index: index,
              isDragging: isDragging,
            )
          : _ExpandedExerciseCard(
              key: ValueKey('expanded_${exercise.id}'),
              exercise: exercise,
              index: index,
              controller: controller,
              onDragStart: onDragStart,
            ),
    );
  }
}

class _ExpandedExerciseCard extends StatelessWidget {
  const _ExpandedExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.controller,
    required this.onDragStart,
  });

  final WorkoutExercise exercise;
  final int index;
  final AppController controller;
  final VoidCallback onDragStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDragStart,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.drag_handle_rounded,
                        color: Color(0xFFB0A898),
                      ),
                    ),
                  ),
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
                ],
              ),
              const SizedBox(height: 16),
              SetTable(
                exercise: exercise,
                isMutating: controller.isMutatingWorkout,
                onAddSet: () => controller.addSet(exercise),
                onLogSet: (weightKg, reps, set) => controller.logSet(
                  exercise: exercise,
                  set: set,
                  reps: reps,
                  weightKg: weightKg,
                ),
                onToggleSet: (set) => controller.toggleSetComplete(
                  exercise: exercise,
                  set: set,
                ),
                onCycleSetType: (type, set) => controller.cycleSetType(
                  exercise: exercise,
                  set: set,
                  newType: type,
                ),
                onRemoveSet: (set) => controller.removeSet(
                  exercise: exercise,
                  set: set,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MinimizedExerciseCard extends StatelessWidget {
  const _MinimizedExerciseCard({
    super.key,
    required this.exerciseName,
    required this.index,
    required this.isDragging,
  });

  final String exerciseName;
  final int index;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: isDragging ? 8 : 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              ReorderableDragStartListener(
                index: index,
                child: Icon(
                  Icons.drag_handle_rounded,
                  color: isDragging ? const Color(0xFFB45309) : const Color(0xFFB0A898),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exerciseName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDragging ? const Color(0xFFB45309) : const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
