import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class ExerciseComparisonPage extends StatefulWidget {
  const ExerciseComparisonPage({super.key});

  @override
  State<ExerciseComparisonPage> createState() => _ExerciseComparisonPageState();
}

class _ExerciseComparisonPageState extends State<ExerciseComparisonPage> {
  int _activeIndex = 3;
  String _selectedExercise = 'Bench Press';

  final List<String> _exercises = [
    'Bench Press',
    'Squat',
    'Deadlift',
    'Overhead Press',
    'Barbell Row',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildExerciseSelector(),
              _buildComparisonChart(),
              _buildStrengthComparison(),
              _buildVolumeComparison(),
              _buildPRComparison(),
              const SizedBox(height: 100),
            ],
          ),
        ),
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
            'COMPARE',
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
                Icons.share,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _exercises.map((exercise) {
            final isSelected = exercise == _selectedExercise;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedExercise = exercise;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GymClubTheme.primaryContainer
                        : GymClubTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    exercise,
                    style: TextStyle(
                      color: isSelected
                          ? GymClubTheme.onPrimaryFixed
                          : GymClubTheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
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
              'STRENGTH COMPARISON',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Compare your strength with the community',
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            _buildComparisonBar('You', 0.78, GymClubTheme.primaryContainer, '140 kg'),
            const SizedBox(height: 16),
            _buildComparisonBar('Avg. Member', 0.55, GymClubTheme.secondary, '98 kg'),
            const SizedBox(height: 16),
            _buildComparisonBar('Top 10%', 0.92, GymClubTheme.tertiary, '165 kg'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GymClubTheme.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GymClubTheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: GymClubTheme.primaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re in the Top 15%',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: GymClubTheme.primaryContainer,
                          ),
                        ),
                        Text(
                          'Keep pushing to reach the elite level!',
                          style: TextStyle(
                            color: GymClubTheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonBar(String label, double percentage, Color color, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthComparison() {
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
                  'BIG 3 LIFTS',
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
                    color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'YOU',
                    style: TextStyle(
                      color: GymClubTheme.primaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLiftCard(
                    'Bench',
                    '140',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.tertiaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLiftCard(
                    'Squat',
                    '180',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLiftCard(
                    'Deadlift',
                    '200',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.primaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLiftCard(
                    'Bench',
                    '105',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.tertiaryContainer,
                    isCommunity: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLiftCard(
                    'Squat',
                    '135',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.secondaryContainer,
                    isCommunity: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLiftCard(
                    'Deadlift',
                    '160',
                    'kg',
                    Icons.fitness_center,
                    GymClubTheme.primaryContainer,
                    isCommunity: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GymClubTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalStat('Total', '520', 'kg', GymClubTheme.onSurface),
                  Container(
                    width: 1,
                    height: 30,
                    color: GymClubTheme.surfaceContainerHighest,
                  ),
                  _buildTotalStat('Community', '400', 'kg', GymClubTheme.onSurfaceVariant),
                  Container(
                    width: 1,
                    height: 30,
                    color: GymClubTheme.surfaceContainerHighest,
                  ),
                  _buildTotalStat('Difference', '+30%', '', GymClubTheme.primaryContainer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiftCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color, {
    bool isCommunity = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCommunity
            ? GymClubTheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: isCommunity ? null : Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCommunity ? GymClubTheme.onSurfaceVariant : color,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (unit.isNotEmpty)
              Text(
                unit,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolumeComparison() {
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
              'VOLUME COMPARISON',
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
                Expanded(
                  child: _buildVolumeStat(
                    'This Month',
                    '42,500',
                    'lbs',
                    GymClubTheme.primaryContainer,
                    '+18% vs last month',
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: GymClubTheme.surfaceContainerHighest,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: _buildVolumeStat(
                    'Community Avg',
                    '32,000',
                    'lbs',
                    GymClubTheme.onSurfaceVariant,
                    'per month',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeStat(
    String label,
    String value,
    String unit,
    Color color,
    String comparison,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 12,
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
                color: color,
              ),
            ),
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
          comparison,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPRComparison() {
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
                  'PR PROGRESSION',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: GymClubTheme.primaryContainer,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPRComparisonRow('Bench Press', '140 kg', '130 kg', '+8%'),
            const SizedBox(height: 12),
            _buildPRComparisonRow('Squat', '180 kg', '165 kg', '+9%'),
            const SizedBox(height: 12),
            _buildPRComparisonRow('Deadlift', '200 kg', '185 kg', '+8%'),
            const SizedBox(height: 12),
            _buildPRComparisonRow('OHP', '90 kg', '75 kg', '+20%'),
            const SizedBox(height: 12),
            _buildPRComparisonRow('Row', '120 kg', '100 kg', '+20%'),
          ],
        ),
      ),
    );
  }

  Widget _buildPRComparisonRow(
    String exercise,
    String yourPR,
    String communityPR,
    String difference,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            exercise,
            style: TextStyle(
              color: GymClubTheme.onSurface,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 8,
                ),
              ),
              Text(
                yourPR,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: GymClubTheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avg',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 8,
                ),
              ),
              Text(
                communityPR,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            difference,
            style: TextStyle(
              color: GymClubTheme.primaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
