import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _activeIndex = 4;
  bool _notificationsEnabled = true;
  bool _restTimerSounds = true;
  bool _hapticFeedback = true;
  bool _darkMode = true;

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
              _buildProfileSection(),
              _buildPreferencesSection(),
              _buildWorkoutSection(),
              _buildNotificationSection(),
              _buildDataSection(),
              _buildDangerZone(),
              _buildVersionInfo(),
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
            'SETTINGS',
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
                Icons.edit,
                color: GymClubTheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: GymClubTheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: GymClubTheme.onPrimaryFixed,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Marcus Chen',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: GymClubTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'marcus@email.com',
                    style: TextStyle(
                      color: GymClubTheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: GymClubTheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PRO MEMBER',
                      style: TextStyle(
                        color: GymClubTheme.primaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
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

  Widget _buildPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.dark_mode,
              iconColor: GymClubTheme.secondary,
              title: 'Dark Mode',
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
                activeColor: GymClubTheme.primary,
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.straighten,
              iconColor: GymClubTheme.tertiary,
              title: 'Units',
              subtitle: 'Metric (kg, cm)',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.language,
              iconColor: GymClubTheme.primaryContainer,
              title: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildWorkoutSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WORKOUT',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.timer,
              iconColor: GymClubTheme.secondary,
              title: 'Rest Timer Sounds',
              trailing: Switch(
                value: _restTimerSounds,
                onChanged: (value) {
                  setState(() {
                    _restTimerSounds = value;
                  });
                },
                activeColor: GymClubTheme.primary,
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.vibration,
              iconColor: GymClubTheme.tertiary,
              title: 'Haptic Feedback',
              trailing: Switch(
                value: _hapticFeedback,
                onChanged: (value) {
                  setState(() {
                    _hapticFeedback = value;
                  });
                },
                activeColor: GymClubTheme.primary,
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.fitness_center,
              iconColor: GymClubTheme.primaryContainer,
              title: 'Default Gym',
              subtitle: 'Iron Paradise Gym',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.format_list_numbered,
              iconColor: GymClubTheme.secondary,
              title: 'Default Sets',
              subtitle: '3 working sets',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICATIONS',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.notifications,
              iconColor: GymClubTheme.tertiary,
              title: 'Push Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: GymClubTheme.primary,
              ),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.schedule,
              iconColor: GymClubTheme.primaryContainer,
              title: 'Workout Reminders',
              subtitle: '16:30 daily',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.restaurant,
              iconColor: GymClubTheme.secondary,
              title: 'Meal Reminders',
              subtitle: 'Enabled',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATA & PRIVACY',
            style: TextStyle(
              color: GymClubTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.cloud_upload,
              iconColor: GymClubTheme.primaryContainer,
              title: 'Export Workout Data',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.cloud_download,
              iconColor: GymClubTheme.secondary,
              title: 'Import Workout Data',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.share,
              iconColor: GymClubTheme.tertiary,
              title: 'Share Profile',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.shield,
              iconColor: GymClubTheme.primary,
              title: 'Privacy Settings',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DANGER ZONE',
            style: TextStyle(
              color: GymClubTheme.error,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.logout,
              iconColor: GymClubTheme.error,
              title: 'Sign Out',
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              iconColor: GymClubTheme.error,
              title: 'Delete Account',
              titleColor: GymClubTheme.error,
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? GymClubTheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right,
                color: GymClubTheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 68),
      color: const Color(0xFF484847).withValues(alpha: 0.3),
    );
  }

  Widget _buildVersionInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            Text(
              'GYM CLUB v2.4.1',
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Electric Lab Theme',
              style: TextStyle(
                color: GymClubTheme.primaryContainer,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
