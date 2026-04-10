import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../app_controller.dart';
import '../widgets/empty_state.dart';

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
              ? const EmptyState(
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
                                Chip(label: Text(humanize(exercise.category))),
                                Chip(label: Text(humanize(exercise.equipment))),
                                ...exercise.muscleGroups.map(
                                  (group) => Chip(label: Text(humanize(group))),
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
