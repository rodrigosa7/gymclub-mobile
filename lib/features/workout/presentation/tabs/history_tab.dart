import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../app_controller.dart';
import '../../data/models/workout_session.dart';
import '../widgets/empty_state.dart';
import '../widgets/info_pill.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.history.isEmpty) {
      return const EmptyState(
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
            .expand<WorkoutSet>((exercise) => exercise.sets)
            .where((set) => set.isComplete)
            .length;

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _showHistoryWorkoutDetails(context, workout),
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
                              'Completed ${formatDateTime(workout.completedAt ?? workout.startedAt)}',
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
                      InfoPill(label: '${workout.exercises.length} exercises'),
                      InfoPill(label: '$completedSetCount completed sets'),
                      if (workout.routineId != null) const InfoPill(label: 'From routine'),
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

  Future<void> _showHistoryWorkoutDetails(
    BuildContext context,
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
                .expand<WorkoutSet>((exercise) => exercise.sets)
                .where((set) => set.isComplete)
                .length;
            final totalVolume = workout.exercises
                .expand<WorkoutSet>((exercise) => exercise.sets)
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
                    'Completed ${formatDateTime(workout.completedAt ?? workout.startedAt)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6C655D),
                        ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      InfoPill(label: '${workout.exercises.length} exercises'),
                      InfoPill(label: '$completedSetCount completed sets'),
                      InfoPill(label: '${formatDouble(totalVolume)} kg total volume'),
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
                  ...workout.exercises.map<Widget>(
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
              InfoPill(label: '${completedSets.length} completed sets'),
              InfoPill(label: '${formatDouble(totalVolume)} kg volume'),
              InfoPill(label: '${exercise.restSeconds}s rest'),
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
          ...exercise.sets.asMap().entries.map<Widget>(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _WorkoutSetTileReadOnly(
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

class _WorkoutSetTileReadOnly extends StatelessWidget {
  const _WorkoutSetTileReadOnly({
    required this.index,
    required this.set,
  });

  final int index;
  final WorkoutSet set;

  @override
  Widget build(BuildContext context) {
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
              color: tone.withAlpha(30),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text('$index'),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF9F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8D9C8)),
                    ),
                    child: Text(
                      set.weightKg?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF9F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8D9C8)),
                    ),
                    child: Text(
                      set.reps?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            height: 36,
            child: Checkbox(
              value: set.isComplete,
              onChanged: null,
              activeColor: const Color(0xFF1F7A4D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
