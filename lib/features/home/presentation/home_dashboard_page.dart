import 'package:flutter/material.dart';

import '../../../core/theme/gymclub_theme.dart';
import '../../../shared/widgets/gymclub_bottom_nav.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildPowerLevel(),
                  const SizedBox(height: 16),
                  _buildUpcomingSession(),
                  const SizedBox(height: 16),
                  _buildMetabolicIntake(),
                  const SizedBox(height: 16),
                  _buildClubPulse(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildFab(),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF484847).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: GymClubTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bolt,
              color: GymClubTheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GYM CLUB',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Mission Control',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: GymClubTheme.onSurface,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Navigate to settings
            },
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

  Widget _buildPowerLevel() {
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
              const Text(
                'POWER LEVEL',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: GymClubTheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GymClubTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '=============',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPowerRing(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optimum Performance',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GymClubTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: GymClubTheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Current Streak',
                          style: TextStyle(
                            color: GymClubTheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '12',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: GymClubTheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Days Active',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerRing() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: 0.94,
              strokeWidth: 8,
              backgroundColor: GymClubTheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(GymClubTheme.primary),
            ),
          ),
          Center(
            child: Text(
              '94',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: GymClubTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSession() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Session',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GymClubTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: GymClubTheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: GymClubTheme.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Heavy Pull Day',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: GymClubTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Back, Biceps & Rear Delts',
                        style: TextStyle(
                          color: GymClubTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: GymClubTheme.secondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '16:30 Today',
                            style: TextStyle(
                              color: GymClubTheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildGradientButton(
            label: 'Resume Protocol',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMetabolicIntake() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metabolic Intake',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildMacroRow(
            icon: Icons.restaurant,
            iconBg: GymClubTheme.tertiaryContainer,
            iconColor: GymClubTheme.onTertiaryContainer,
            label: 'Protein',
            progress: 0.75,
            value: '165g / 220g',
            valueColor: GymClubTheme.primary,
          ),
          const SizedBox(height: 16),
          _buildMacroRow(
            icon: Icons.bakery_dining,
            iconBg: GymClubTheme.secondaryContainer,
            iconColor: GymClubTheme.onSecondaryContainer,
            label: 'Carbs',
            progress: 0.54,
            value: '140g / 260g',
            valueColor: GymClubTheme.secondary,
          ),
          const SizedBox(height: 16),
          _buildMacroRow(
            icon: Icons.oil_barrel,
            iconBg: GymClubTheme.surfaceContainerHighest,
            iconColor: GymClubTheme.primary,
            label: 'Fats',
            progress: 0.82,
            value: '58g / 70g',
            valueColor: GymClubTheme.primaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required double progress,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: GymClubTheme.onSurface,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubPulse() {
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
              const Text(
                'Club Pulse',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: GymClubTheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View Global',
                  style: TextStyle(
                    color: GymClubTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeedItem(
            avatar: Icons.person,
            badge: 'PR',
            badgeColor: GymClubTheme.tertiaryContainer,
            textColor: GymClubTheme.onTertiaryContainer,
            message: 'Alex J. just smashed a 140kg Bench PR!',
            likes: 24,
          ),
          const SizedBox(height: 12),
          _buildFeedItem(
            avatar: Icons.event,
            badge: 'EVENT',
            badgeColor: GymClubTheme.secondaryContainer,
            textColor: GymClubTheme.onSecondaryContainer,
            message: 'Saturday Shred: 14 slots remaining.',
            time: 'Starts in 3h',
            isEvent: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem({
    required IconData avatar,
    required String badge,
    required Color badgeColor,
    required Color textColor,
    required String message,
    int? likes,
    String? time,
    bool isEvent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: GymClubTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(avatar, color: GymClubTheme.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (likes != null)
                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: GymClubTheme.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$likes Kudos',
                        style: TextStyle(
                          color: GymClubTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (time != null)
                  Row(
                    children: [
                      Icon(Icons.schedule, color: GymClubTheme.tertiary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          color: GymClubTheme.tertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
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
        child: Text(
          label,
          style: const TextStyle(
            color: GymClubTheme.onPrimaryFixed,
            fontFamily: 'SpaceGrotesk',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 80,
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: GymClubTheme.primaryContainer,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: GymClubTheme.onPrimaryFixed,
            ),
          ),
        ),
      ),
    );
  }
}