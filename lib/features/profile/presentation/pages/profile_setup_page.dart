import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedGoal = -1;
  int _selectedLevel = -1;
  int _selectedGender = -1;

  final List<String> _goals = ['Build Muscle', 'Get Stronger', 'Lose Fat', 'Maintain'];
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  double _weight = 75.0;
  double _height = 175.0;
  int _age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildGoalPage(),
                  _buildStatsPage(),
                  _buildBodyStatsPage(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
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
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? GymClubTheme.primaryContainer : GymClubTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: GymClubTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: GymClubTheme.onPrimaryFixed,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Welcome to the Club',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: GymClubTheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Let's set up your profile to personalize your training experience.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 48),
          _buildFeatureItem(Icons.track_changes, 'Personalized workout plans'),
          const SizedBox(height: 16),
          _buildFeatureItem(Icons.show_chart, 'Track your progress'),
          const SizedBox(height: 16),
          _buildFeatureItem(Icons.emoji_events, 'Achieve PRs'),
          const SizedBox(height: 16),
          _buildFeatureItem(Icons.groups, 'Join the community'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: GymClubTheme.primaryContainer),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              color: GymClubTheme.onSurface,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "What's your goal?",
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the goal that best describes what you want to achieve.',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(_goals.length, (index) {
            final isSelected = _selectedGoal == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGoal = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GymClubTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: GymClubTheme.primaryContainer, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? GymClubTheme.primaryContainer
                              : GymClubTheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: GymClubTheme.onPrimaryFixed, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _goals[index],
                        style: const TextStyle(
                          color: GymClubTheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Your experience level?',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This helps us customize the workout intensity for you.',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(_levels.length, (index) {
            final isSelected = _selectedLevel == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLevel = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GymClubTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: GymClubTheme.primaryContainer, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? GymClubTheme.primaryContainer
                              : GymClubTheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: GymClubTheme.onPrimaryFixed, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _levels[index],
                              style: const TextStyle(
                                color: GymClubTheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getLevelDescription(index),
                              style: TextStyle(
                                color: GymClubTheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          const Text(
            'Biological sex',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_genders.length, (index) {
              final isSelected = _selectedGender == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: GymClubTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: GymClubTheme.primaryContainer, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        _genders[index],
                        style: TextStyle(
                          color: isSelected
                              ? GymClubTheme.primaryContainer
                              : GymClubTheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getLevelDescription(int index) {
    switch (index) {
      case 0:
        return 'Less than 6 months of training';
      case 1:
        return '6 months to 2 years of training';
      case 2:
        return 'More than 2 years of training';
      default:
        return '';
    }
  }

  Widget _buildBodyStatsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Body statistics',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This helps us calculate your optimal macros and strength standards.',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          _buildStatSlider('Weight', _weight, 40, 150, 'kg', GymClubTheme.primaryContainer),
          const SizedBox(height: 24),
          _buildStatSlider('Height', _height, 140, 210, 'cm', GymClubTheme.secondary),
          const SizedBox(height: 24),
          _buildStatSlider('Age', _age.toDouble(), 16, 80, 'years', GymClubTheme.tertiary),
        ],
      ),
    );
  }

  Widget _buildStatSlider(
    String label,
    double value,
    double min,
    double max,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: GymClubTheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    label == 'Age' ? value.toInt().toString() : value.toInt().toString(),
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: TextStyle(
                      color: GymClubTheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: GymClubTheme.surfaceContainerHighest,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: (newValue) {
                setState(() {
                  if (label == 'Weight') {
                    _weight = newValue;
                  } else if (label == 'Height') {
                    _height = newValue;
                  } else {
                    _age = newValue.toInt();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: GymClubTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < 3) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Complete setup
                }
              },
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
                  Text(
                    _currentPage < 3 ? 'CONTINUE' : 'COMPLETE SETUP',
                    style: const TextStyle(
                      color: GymClubTheme.onPrimaryFixed,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: GymClubTheme.onPrimaryFixed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Skip setup
            },
            child: Text(
              'Skip for now',
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
