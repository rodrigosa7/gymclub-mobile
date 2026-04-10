import 'package:flutter/material.dart';

import '../../../../core/utils/format_utils.dart';
import '../app_controller.dart';
import '../widgets/metric_card.dart';

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
              MetricCard(
                title: 'Sessions',
                value: analytics.totalSessions.toString(),
                caption: 'completed workouts',
                accent: const Color(0xFF335C67),
              ),
              MetricCard(
                title: 'Sets',
                value: analytics.totalSets.toString(),
                caption: 'logged working volume',
                accent: const Color(0xFF9C6644),
              ),
              MetricCard(
                title: 'Volume',
                value: '${formatDouble(analytics.totalVolumeKg)} kg',
                caption: 'total tracked load',
                accent: const Color(0xFF588157),
              ),
              MetricCard(
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
                        '${activeWorkout.exercises.length} exercises - started ${formatDateTime(activeWorkout.startedAt)}',
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
