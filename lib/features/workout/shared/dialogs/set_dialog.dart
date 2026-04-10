import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../../presentation/app_controller.dart';
import '../../data/models/workout_session.dart';
import '../../presentation/widgets/history_exercise_section.dart';
import '../../presentation/widgets/info_pill.dart';

class SetDraft {
  const SetDraft({
    required this.reps,
    required this.weightKg,
    required this.rir,
  });

  final int? reps;
  final double? weightKg;
  final int? rir;
}

Future<SetDraft?> showSetDialog(
  BuildContext context, {
  WorkoutSet? existingSet,
}) async {
  final repsController = TextEditingController(
    text: existingSet?.reps?.toString() ?? '',
  );
  final weightController = TextEditingController(
    text: existingSet?.weightKg == null ? '' : formatDouble(existingSet!.weightKg!),
  );
  final rirController = TextEditingController(
    text: existingSet?.rir?.toString() ?? '',
  );

  try {
    return await showModalBottomSheet<SetDraft>(
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
                                  SetDraft(
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

Future<bool?> confirmAction(
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

Future<void> showHistoryWorkoutDetails(
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
                  (exercise) => HistoryExerciseSection(
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
