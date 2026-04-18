import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class ExerciseDetailsPage extends StatefulWidget {
  const ExerciseDetailsPage({super.key});

  @override
  State<ExerciseDetailsPage> createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
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
                  _buildExerciseHeader(),
                  const SizedBox(height: 16),
                  _buildMuscleGroupDiagram(),
                  _buildTechniqueSection(),
                  _buildSetsHistory(),
                  _buildPRSection(),
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
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GymClubTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'GYM CLUB',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GymClubTheme.primary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GymClubTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.share,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'COMPOUND • UPPER BODY',
              style: TextStyle(
                color: GymClubTheme.primaryContainer,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Barbell Bench Press',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatChip(Icons.arrow_upward, 'Chest, Triceps, Shoulders'),
              const SizedBox(width: 12),
              _buildStatChip(Icons.bar_chart, '94% efficiency'),
            ],
          ),
          const SizedBox(height: 16),
          _buildGradientButton(
            label: 'Start Exercise',
            icon: Icons.play_arrow,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: GymClubTheme.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupDiagram() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MUSCLE GROUPS',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMuscleIndicator('Chest', 0.9, GymClubTheme.primaryContainer),
                const SizedBox(width: 16),
                _buildMuscleIndicator('Triceps', 0.7, GymClubTheme.secondary),
                const SizedBox(width: 16),
                _buildMuscleIndicator('Front Delts', 0.5, GymClubTheme.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleIndicator(String label, double intensity, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: intensity * 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.5),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fitness_center,
                color: color.withValues(alpha: intensity),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(intensity * 100).toInt()}%',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TECHNIQUE',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GymClubTheme.tertiaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'VIDEO',
                    style: TextStyle(
                      color: GymClubTheme.tertiaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTechniqueStep('1', 'Lie flat on bench, grip bar wider than shoulder width'),
            const SizedBox(height: 12),
            _buildTechniqueStep('2', 'Unrack and lower bar to mid-chest with elbows at 75°'),
            const SizedBox(height: 12),
            _buildTechniqueStep('3', 'Drive feet into floor and press bar up explosively'),
            const SizedBox(height: 12),
            _buildTechniqueStep('4', 'Lock out arms at top, control descent'),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: GymClubTheme.primaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetsHistory() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SETS HISTORY',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryHeader(),
            const SizedBox(height: 8),
            _buildHistoryRow('Today', '225 x 8', '225 x 8', '225 x 8', true),
            _buildHistoryRow('2 days ago', '225 x 8', '225 x 8', '225 x 8', true),
            _buildHistoryRow('4 days ago', '215 x 8', '215 x 8', '-', false),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            'DATE',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'SET 1',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'SET 2',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'SET 3',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryRow(
    String date,
    String set1,
    String set2,
    String set3,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              date,
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              set1,
              style: TextStyle(
                color: isCompleted ? GymClubTheme.onSurface : GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              set2,
              style: TextStyle(
                color: isCompleted ? GymClubTheme.onSurface : GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              set3,
              style: TextStyle(
                color: isCompleted ? GymClubTheme.onSurface : GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPRSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PERSONAL RECORDS',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  Icons.emoji_events,
                  color: GymClubTheme.tertiary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPRCard(
                    label: '1RM',
                    value: '140',
                    unit: 'kg',
                    date: '2 weeks ago',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPRCard(
                    label: 'Volume',
                    value: '12,450',
                    unit: 'lbs',
                    date: 'Today',
                    isHighlighted: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPRCard({
    required String label,
    required String value,
    required String unit,
    required String date,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? GymClubTheme.tertiaryContainer.withValues(alpha: 0.2)
            : GymClubTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: GymClubTheme.tertiaryContainer.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isHighlighted ? GymClubTheme.tertiary : GymClubTheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
            ),
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
}
