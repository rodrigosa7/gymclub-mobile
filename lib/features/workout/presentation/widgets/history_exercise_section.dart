import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../app_controller.dart';
import '../../data/models/workout_session.dart';
import 'info_pill.dart';
import 'workout_set_tile.dart';

class HistoryExerciseSection extends StatelessWidget {
  const HistoryExerciseSection({
    super.key,
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
              child: WorkoutSetTile(
                index: entry.key + 1,
                set: entry.value,
                onLog: null,
                onRemove: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
