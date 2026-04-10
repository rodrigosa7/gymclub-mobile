import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../widgets/empty_state.dart';

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
      return const EmptyState(
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
