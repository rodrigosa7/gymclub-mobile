import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class ExerciseHistoryPage extends StatefulWidget {
  const ExerciseHistoryPage({super.key});

  @override
  State<ExerciseHistoryPage> createState() => _ExerciseHistoryPageState();
}

class _ExerciseHistoryPageState extends State<ExerciseHistoryPage> {
  int _activeIndex = 3;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'This Week', 'This Month', '3 Months'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 16),
                    _buildWorkoutHistory(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
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
            'EXERCISE HISTORY',
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
                Icons.filter_list,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = filter == _selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
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
                    filter,
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

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GymClubTheme.primaryContainer.withValues(alpha: 0.3),
              GymClubTheme.secondary.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: GymClubTheme.primaryContainer.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TOTAL VOLUME',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  '284,520',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: GymClubTheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'lbs',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryChip('42', 'Workouts'),
                const SizedBox(width: 16),
                _buildSummaryChip('12', 'PRs Broken'),
                const SizedBox(width: 16),
                _buildSummaryChip('28', 'Days Active'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryChip(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: GymClubTheme.primary,
          ),
        ),
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

  Widget _buildWorkoutHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WORKOUT LOG',
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildWorkoutCard(
          title: 'Push Day',
          date: 'Today • 16:30',
          exercises: 6,
          volume: '24,500 lbs',
          duration: '58 mins',
          intensity: 92,
        ),
        const SizedBox(height: 12),
        _buildWorkoutCard(
          title: 'Pull Day',
          date: '2 days ago • 17:00',
          exercises: 7,
          volume: '18,200 lbs',
          duration: '52 mins',
          intensity: 85,
        ),
        const SizedBox(height: 12),
        _buildWorkoutCard(
          title: 'Leg Day',
          date: '4 days ago • 08:00',
          exercises: 8,
          volume: '32,800 lbs',
          duration: '65 mins',
          intensity: 88,
        ),
        const SizedBox(height: 12),
        _buildWorkoutCard(
          title: 'Upper Body',
          date: '6 days ago • 07:30',
          exercises: 5,
          volume: '15,400 lbs',
          duration: '48 mins',
          intensity: 78,
        ),
      ],
    );
  }

  Widget _buildWorkoutCard({
    required String title,
    required String date,
    required int exercises,
    required String volume,
    required String duration,
    required int intensity,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GymClubTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: GymClubTheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getIntensityColor(intensity).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: _getIntensityColor(intensity),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$intensity%',
                      style: TextStyle(
                        color: _getIntensityColor(intensity),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildWorkoutStat(Icons.fitness_center, '$exercises exercises'),
              const SizedBox(width: 16),
              _buildWorkoutStat(Icons.show_chart, volume),
              const SizedBox(width: 16),
              _buildWorkoutStat(Icons.timer, duration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: GymClubTheme.onSurfaceVariant, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getIntensityColor(int intensity) {
    if (intensity >= 90) return GymClubTheme.tertiary;
    if (intensity >= 80) return GymClubTheme.primaryContainer;
    return GymClubTheme.secondary;
  }
}
