import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class ExerciseStatisticsPage extends StatefulWidget {
  const ExerciseStatisticsPage({super.key});

  @override
  State<ExerciseStatisticsPage> createState() => _ExerciseStatisticsPageState();
}

class _ExerciseStatisticsPageState extends State<ExerciseStatisticsPage> {
  int _activeIndex = 3;
  String _selectedPeriod = '1 Month';

  final List<String> _periods = ['1 Week', '1 Month', '3 Months', '1 Year', 'All'];

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
              _buildPeriodSelector(),
              _buildStrengthChart(),
              _buildVolumeChart(),
              _buildMuscleDistribution(),
              _buildPRTimeline(),
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
            'STATISTICS',
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

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _periods.map((period) {
            final isSelected = period == _selectedPeriod;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = period;
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
                    period,
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

  Widget _buildStrengthChart() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'STRENGTH PROGRESS',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    _buildLegendDot(GymClubTheme.primaryContainer, 'Bench'),
                    const SizedBox(width: 12),
                    _buildLegendDot(GymClubTheme.secondary, 'Squat'),
                    const SizedBox(width: 12),
                    _buildLegendDot(GymClubTheme.tertiary, 'Deadlift'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ChartPainter(),
    );
  }

  Widget _buildVolumeChart() {
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
                  'WEEKLY VOLUME',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '42,500 lbs',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: GymClubTheme.primary,
                      ),
                    ),
                    Text(
                      'This week',
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVolumeBar('Mon', 0.65, GymClubTheme.primaryContainer),
                _buildVolumeBar('Tue', 0.45, GymClubTheme.primaryContainer),
                _buildVolumeBar('Wed', 0.80, GymClubTheme.primaryContainer),
                _buildVolumeBar('Thu', 0.55, GymClubTheme.primaryContainer),
                _buildVolumeBar('Fri', 0.90, GymClubTheme.primaryContainer),
                _buildVolumeBar('Sat', 0.70, GymClubTheme.primaryContainer),
                _buildVolumeBar('Sun', 0.30, GymClubTheme.primaryContainer),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeBar(String day, double height, Color color) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 120,
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 32,
              height: 120 * height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.8),
                    color,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleDistribution() {
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
              'MUSCLE DISTRIBUTION',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            _buildMuscleRow('Chest', 0.85, GymClubTheme.primaryContainer),
            const SizedBox(height: 12),
            _buildMuscleRow('Back', 0.72, GymClubTheme.secondary),
            const SizedBox(height: 12),
            _buildMuscleRow('Shoulders', 0.65, GymClubTheme.tertiary),
            const SizedBox(height: 12),
            _buildMuscleRow('Arms', 0.55, GymClubTheme.primary),
            const SizedBox(height: 12),
            _buildMuscleRow('Legs', 0.40, GymClubTheme.tertiaryContainer),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleRow(String muscle, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              muscle,
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 14,
              ),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPRTimeline() {
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
                  'PR TIMELINE',
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
                    '12 NEW',
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
            _buildPRItem('Bench Press', '140 kg', '2 weeks ago', Icons.emoji_events),
            _buildPRItem('Squat', '180 kg', '1 month ago', Icons.emoji_events),
            _buildPRItem('Deadlift', '200 kg', '6 weeks ago', Icons.emoji_events),
          ],
        ),
      ),
    );
  }

  Widget _buildPRItem(String exercise, String weight, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GymClubTheme.tertiaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: GymClubTheme.tertiaryContainer, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise,
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            weight,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final benchPaint = Paint()
      ..color = GymClubTheme.primaryContainer
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final squatPaint = Paint()
      ..color = GymClubTheme.secondary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final deadliftPaint = Paint()
      ..color = GymClubTheme.tertiary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = GymClubTheme.surfaceContainerHighest
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final benchPoints = [
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.4, size.height * 0.55),
      Offset(size.width * 0.55, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.95, size.height * 0.2),
    ];

    final squatPoints = [
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.25, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.55, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.3),
      Offset(size.width * 0.95, size.height * 0.25),
    ];

    final deadliftPoints = [
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.25, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.55, size.height * 0.55),
      Offset(size.width * 0.7, size.height * 0.45),
      Offset(size.width * 0.85, size.height * 0.35),
      Offset(size.width * 0.95, size.height * 0.3),
    ];

    _drawLine(canvas, benchPoints, benchPaint);
    _drawLine(canvas, squatPoints, squatPaint);
    _drawLine(canvas, deadliftPoints, deadliftPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> points, Paint paint) {
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
