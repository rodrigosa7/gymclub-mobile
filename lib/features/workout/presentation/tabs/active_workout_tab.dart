import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final Future<void> Function(DateTime? completedAt) onCompleteWorkout;
  final VoidCallback onOpenRoutines;

  @override
  State<ActiveWorkoutTab> createState() => ActiveWorkoutTabState();
}

class ActiveWorkoutTabState extends State<ActiveWorkoutTab> {
  bool _isReorderMode = false;
  DateTime? _editedCompletedAt;
  bool _isTimerStopped = false;
  Duration? _frozenDuration;

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _isTimerStopped) return;
      setState(() {});
      _startTimer();
    });
  }

  void _stopTimer() {
    _isTimerStopped = true;
  }

  void _resumeTimer() {
    _isTimerStopped = false;
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _enterReorderMode() {
    HapticFeedback.mediumImpact();
    setState(() => _isReorderMode = true);
  }

  void showFinishWorkoutSheet() {
    final workout = widget.controller.activeWorkout;
    if (workout == null) return;

    // Validate: check if at least one set is completed
    final hasCompletedSets = workout.exercises.any(
      (ex) => ex.sets.any((s) => s.isComplete),
    );

    if (!hasCompletedSets) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete at least one set before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _showFinishWorkoutSheet(context);
  }

  void _showFinishWorkoutSheet(BuildContext ctx) {
    final workout = widget.controller.activeWorkout;
    if (workout == null) return;

    // Stop the live timer and freeze duration at current value
    _stopTimer();
    _frozenDuration = workout.elapsed;

    final nameController = TextEditingController(text: workout.name);
    final notesController = TextEditingController(text: workout.notes);

    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D9C8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Finish Workout',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setSheetState) {
                return GestureDetector(
                  onTap: () {
                    _showDurationPicker(
                      context,
                      _frozenDuration ?? workout.elapsed,
                      workout.startedAt,
                      () => setSheetState(() {}),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Duration: ${formatDuration(_editedCompletedAt != null ? _editedCompletedAt!.difference(workout.startedAt) : (_frozenDuration ?? workout.elapsed))}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6C655D),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Color(0xFFB0A898),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Workout name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      _confirmDiscardWorkout(ctx);
                      _resumeTimer();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Discard'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      widget.controller.updateWorkoutName(nameController.text.trim());
                      widget.onCompleteWorkout(_editedCompletedAt);
                      _resumeTimer();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Workout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDiscardWorkout(BuildContext ctx) {
    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Discard workout?'),
        content: const Text('This will delete the workout and all logged sets.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              widget.controller.discardActiveWorkout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker(BuildContext ctx, Duration currentDuration, DateTime startedAt, VoidCallback onChanged) {
    int minutes = currentDuration.inMinutes;
    int seconds = currentDuration.inSeconds % 60;

    showModalBottomSheet<void>(
      context: ctx,
      builder: (sheetCtx) => SafeArea(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(sheetCtx);
                        setState(() {
                          _editedCompletedAt = startedAt.add(
                            Duration(minutes: minutes, seconds: seconds),
                          );
                        });
                        onChanged();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.ms,
                  initialTimerDuration: currentDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    minutes = newDuration.inMinutes;
                    seconds = newDuration.inSeconds % 60;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          height: _isReorderMode ? 48 : 0,
          child: _isReorderMode
              ? Container(
                  color: const Color(0xFF1F2937),
                  alignment: Alignment.center,
                  child: const Text(
                    'Long-press to reorder',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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
                          : () => showFinishWorkoutSheet(),
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
              GestureDetector(
                onLongPress: _isReorderMode ? null : _enterReorderMode,
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: workout.exercises.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    widget.controller.reorderExercise(oldIndex, newIndex);
                  },
                  onReorderEnd: (index) {
                    if (mounted) setState(() => _isReorderMode = false);
                  },
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final scale = Curves.easeInOut.transform(animation.value);
                        return Transform.scale(
                          scale: 1.0 + (scale * 0.03),
                          child: Material(
                            elevation: 4 + (scale * 4),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            child: child,
                          ),
                        );
                      },
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final exercise = workout.exercises[index];
                    if (_isReorderMode) {
                      return _ReorderableExerciseTile(
                        key: ValueKey(exercise.id),
                        exerciseName: widget.controller.exerciseName(exercise.exerciseId),
                        index: index,
                      );
                    }
                    return _ExerciseCard(
                      key: ValueKey(exercise.id),
                      exercise: exercise,
                      index: index,
                      controller: widget.controller,
                    );
                  },
                ),
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
  });

  final WorkoutExercise exercise;
  final int index;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
              ],
            ),
            const SizedBox(height: 16),
            SetTable(
              exercise: exercise,
              isMutating: controller.isMutatingWorkout,
              onAddSet: () => controller.addSet(exercise),
              onLogSet: (weightKg, reps, set) {
                try {
                  controller.logSet(
                    exercise: exercise,
                    set: set,
                    reps: reps,
                    weightKg: weightKg,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceFirst('StateError: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              onToggleSet: (set) {
                try {
                  controller.toggleSetComplete(exercise: exercise, set: set);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceFirst('StateError: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
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
    );
  }
}

class _ReorderableExerciseTile extends StatelessWidget {
  const _ReorderableExerciseTile({
    super.key,
    required this.exerciseName,
    required this.index,
  });

  final String exerciseName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8D9C8)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                exerciseName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.drag_handle_rounded, color: Color(0xFFB0A898)),
          ],
        ),
      ),
    );
  }
}
