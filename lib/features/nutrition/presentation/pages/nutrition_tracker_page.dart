import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class NutritionTrackerPage extends StatefulWidget {
  const NutritionTrackerPage({super.key});

  @override
  State<NutritionTrackerPage> createState() => _NutritionTrackerPageState();
}

class _NutritionTrackerPageState extends State<NutritionTrackerPage> {
  int _activeIndex = 1;

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
                  _buildDailyGoal(),
                  _buildMacrosSection(),
                  _buildMealSchedule(),
                  _buildWaterIntake(),
                  _buildSupplements(),
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
            'NUTRITION',
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

  Widget _buildDailyGoal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GymClubTheme.primaryContainer.withValues(alpha: 0.15),
              GymClubTheme.secondary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: GymClubTheme.primaryContainer.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DAILY GOAL',
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
                    'BULKING',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2,450',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: GymClubTheme.onSurface,
                        ),
                      ),
                      Text(
                        'kcal remaining',
                        style: TextStyle(
                          color: GymClubTheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCircularProgress(),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    GymClubTheme.primary,
                    GymClubTheme.primary.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1,550 kcal consumed',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '4,000 kcal target',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: 0.39,
              strokeWidth: 8,
              backgroundColor: GymClubTheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(GymClubTheme.primaryContainer),
            ),
          ),
          Center(
            child: Text(
              '39%',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GymClubTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MACRONUTRIENTS',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  icon: Icons.restaurant,
                  iconBg: GymClubTheme.tertiaryContainer,
                  iconColor: GymClubTheme.onTertiaryContainer,
                  label: 'Protein',
                  current: 165,
                  target: 220,
                  unit: 'g',
                  color: GymClubTheme.tertiaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  icon: Icons.bakery_dining,
                  iconBg: GymClubTheme.secondaryContainer,
                  iconColor: GymClubTheme.onSecondaryContainer,
                  label: 'Carbs',
                  current: 140,
                  target: 260,
                  unit: 'g',
                  color: GymClubTheme.secondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMacroCard(
            icon: Icons.oil_barrel,
            iconBg: GymClubTheme.surfaceContainerHighest,
            iconColor: GymClubTheme.primary,
            label: 'Fats',
            current: 58,
            target: 70,
            unit: 'g',
            color: GymClubTheme.primaryContainer,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required int current,
    required int target,
    required String unit,
    required Color color,
    bool isFullWidth = false,
  }) {
    final percentage = current / target;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: GymClubTheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$current',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                ' / $target$unit',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildMealSchedule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MEAL SCHEDULE',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+ ADD MEAL',
                    style: TextStyle(
                      color: GymClubTheme.primaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            mealTime: '06:30',
            mealName: 'Breakfast',
            foods: 'Oats, 4 Eggs, Banana Protein Shake',
            calories: 650,
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            mealTime: '09:30',
            mealName: 'Morning Snack',
            foods: 'Greek Yogurt, Almonds, Apple',
            calories: 320,
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            mealTime: '13:00',
            mealName: 'Lunch',
            foods: 'Grilled Chicken, Rice, Broccoli',
            calories: 580,
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            mealTime: '16:30',
            mealName: 'Pre-Workout',
            foods: 'Protein Bar, Coffee',
            calories: 250,
            isUpcoming: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String mealTime,
    required String mealName,
    required String foods,
    required int calories,
    bool isCompleted = false,
    bool isUpcoming = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: isUpcoming
            ? Border.all(color: GymClubTheme.primaryContainer.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                mealTime,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isUpcoming ? GymClubTheme.primaryContainer : GymClubTheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 2,
                color: isCompleted
                    ? GymClubTheme.primaryContainer
                    : GymClubTheme.surfaceContainerHighest,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealName,
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  foods,
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$calories',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isUpcoming ? GymClubTheme.primaryContainer : GymClubTheme.onSurface,
                ),
              ),
              Text(
                'kcal',
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

  Widget _buildWaterIntake() {
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
                  'HYDRATION',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: GymClubTheme.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '2.1L / 3L',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: GymClubTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                final isFilled = index < 5;
                return Container(
                  width: 40,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? GymClubTheme.secondary.withValues(alpha: 0.3)
                        : GymClubTheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFilled
                          ? GymClubTheme.secondary.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.water_drop,
                      color: isFilled
                          ? GymClubTheme.secondary
                          : GymClubTheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplements() {
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
            const Text(
              'SUPPLEMENTS',
              style: TextStyle(
                color: GymClubTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            _buildSupplementItem('Creatine', '5g', true),
            const SizedBox(height: 12),
            _buildSupplementItem('Whey Protein', '30g', true),
            const SizedBox(height: 12),
            _buildSupplementItem('Pre-Workout', '1 scoop', false),
            const SizedBox(height: 12),
            _buildSupplementItem('Vitamin D', '5000 IU', false),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplementItem(String name, String dosage, bool isTaken) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isTaken
                ? GymClubTheme.primaryContainer.withValues(alpha: 0.2)
                : GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isTaken ? Icons.check : Icons.schedule,
            color: isTaken ? GymClubTheme.primaryContainer : GymClubTheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: GymClubTheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                dosage,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isTaken)
          Icon(
            Icons.check_circle,
            color: GymClubTheme.primaryContainer,
            size: 20,
          ),
      ],
    );
  }
}
