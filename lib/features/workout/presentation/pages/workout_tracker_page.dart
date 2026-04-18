import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class WorkoutTrackerPage extends StatefulWidget {
  const WorkoutTrackerPage({super.key});

  @override
  State<WorkoutTrackerPage> createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> {
  int _activeIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildHeroSection(),
                  const SizedBox(height: 16),
                  _buildRestTimer(),
                  _buildStatsGrid(),
                  _buildExercisesSection(),
                  _buildActionButtons(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StandardBottomNav(
        activeIndex: _activeIndex,
        onTap: (index) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GYM CLUB',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GymClubTheme.primary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GymClubTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.settings,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Afternoon',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Push Session',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GymClubTheme.primary,
                  GymClubTheme.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatPill('Volume: 12,450 lbs'),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF484847),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatPill('42 mins'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String text) {
    return Text(
      text,
      style: TextStyle(
        color: GymClubTheme.onSurfaceVariant,
        fontSize: 14,
      ),
    );
  }

  Widget _buildRestTimer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF001a1a).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00e3fd).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rest Timer',
                  style: TextStyle(
                    color: GymClubTheme.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '01:45',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: GymClubTheme.secondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.timer,
              color: GymClubTheme.secondary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.bolt,
              iconColor: GymClubTheme.primary,
              value: '88%',
              label: 'Intensity',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite,
              iconColor: GymClubTheme.tertiary,
              value: '142',
              label: 'Avg BPM',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_fire_department,
              iconColor: const Color(0xFFff6e84),
              value: '320',
              label: 'Kcal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXERCISES',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildExerciseCard(
            title: 'Barbell Bench Press',
            category: 'Chest • Compounds',
            sets: [
              {'weight': '225 x 8', 'reps': '8', 'completed': true},
              {'weight': '225 x 8', 'reps': '8', 'completed': true},
            ],
          ),
          const SizedBox(height: 12),
          _buildExerciseCard(
            title: 'Dumbbell Lateral Raise',
            category: 'Shoulders • Isolation',
            sets: [
              {'weight': '30 x 12', 'reps': '12', 'completed': true},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String category,
    required List<Map<String, dynamic>> sets,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: GymClubTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: GymClubTheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSetTable(sets),
          const SizedBox(height: 12),
          _buildAddSetButton(),
        ],
      ),
    );
  }

  Widget _buildSetTable(List<Map<String, dynamic>> sets) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                'SET',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'PREVIOUS',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'LBS',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...sets.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final set = entry.value;
          return _buildSetRow(
            number: index.toString(),
            weight: set['weight'] as String,
            reps: set['reps'] as String,
            completed: set['completed'] as bool,
          );
        }),
      ],
    );
  }

  Widget _buildSetRow({
    required String number,
    required String weight,
    required String reps,
    required bool completed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              number,
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              weight,
              style: const TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              reps,
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? GymClubTheme.primary : GymClubTheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSetButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF484847),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '+ Add Set',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGradientButton(
            label: 'Add Exercise',
            icon: Icons.add,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSecondaryButton(
            label: 'Finish Workout',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: GymClubTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: GymClubTheme.onPrimaryFixed),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: GymClubTheme.onPrimaryFixed,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: GymClubTheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}