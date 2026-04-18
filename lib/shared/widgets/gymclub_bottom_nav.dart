import 'package:flutter/material.dart';

import '../../core/theme/gymclub_theme.dart';

class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
}

class GymClubBottomNav extends StatelessWidget {
  const GymClubBottomNav({
    super.key,
    required this.items,
    this.showFab = false,
    this.fabOnTap,
    this.fabIcon = Icons.add,
  });

  final List<BottomNavItem> items;
  final bool showFab;
  final VoidCallback? fabOnTap;
  final IconData fabIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GymClubTheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF484847).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) => _buildNavItem(item)).toList(),
              ),
            ),
            if (showFab)
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: GestureDetector(
                  onTap: fabOnTap,
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
                    child: Icon(
                      fabIcon,
                      color: GymClubTheme.onPrimaryFixed,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item) {
    final isActive = item.isActive;
    final color = isActive ? GymClubTheme.primary : GymClubTheme.onSurfaceVariant;

    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? (item.activeIcon ?? item.icon) : item.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Convenience builder for standard 5-tab nav
class StandardBottomNav extends StatelessWidget {
  const StandardBottomNav({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  final int activeIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return GymClubBottomNav(
      items: [
        BottomNavItem(
          icon: Icons.dynamic_feed_outlined,
          activeIcon: Icons.dynamic_feed,
          label: 'Feed',
          isActive: activeIndex == 0,
          onTap: () => onTap(0),
        ),
        BottomNavItem(
          icon: Icons.event_note_outlined,
          activeIcon: Icons.event_note,
          label: 'Plan',
          isActive: activeIndex == 1,
          onTap: () => onTap(1),
        ),
        BottomNavItem(
          icon: Icons.fitness_center_outlined,
          activeIcon: Icons.fitness_center,
          label: 'Gym',
          isActive: activeIndex == 2,
          onTap: () => onTap(2),
        ),
        BottomNavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
          label: 'Stats',
          isActive: activeIndex == 3,
          onTap: () => onTap(3),
        ),
        BottomNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          isActive: activeIndex == 4,
          onTap: () => onTap(4),
        ),
      ],
    );
  }
}