import 'package:flutter/material.dart';

import '../../../../core/theme/gymclub_theme.dart';
import '../../../../shared/widgets/gymclub_bottom_nav.dart';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  int _activeIndex = 0;

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
              _buildSearchBar(),
              _buildCategories(),
              _buildFeed(),
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
            'CLUB FEED',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GymClubTheme.primary,
            ),
          ),
          Row(
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
                    Icons.notifications,
                    color: GymClubTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GymClubTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: GymClubTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: GymClubTheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Search workouts, users, exercises...',
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryChip('All', isSelected: true),
            const SizedBox(width: 8),
            _buildCategoryChip('PRs'),
            const SizedBox(width: 8),
            _buildCategoryChip('Events'),
            const SizedBox(width: 8),
            _buildCategoryChip('Tips'),
            const SizedBox(width: 8),
            _buildCategoryChip('Following'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? GymClubTheme.primary
              : GymClubTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? GymClubTheme.onPrimaryFixed
                : GymClubTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFeed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildFeedCard(
            avatar: Icons.person,
            name: 'Alex Johnson',
            time: '2 hours ago',
            badge: 'PR',
            badgeColor: GymClubTheme.tertiaryContainer,
            textColor: GymClubTheme.onTertiaryContainer,
            content: _buildPRContent(),
            likes: 42,
            comments: 8,
          ),
          const SizedBox(height: 16),
          _buildFeedCard(
            avatar: Icons.event,
            name: 'Saturday Shred Event',
            time: '5 hours ago',
            badge: 'EVENT',
            badgeColor: GymClubTheme.secondaryContainer,
            textColor: GymClubTheme.onSecondaryContainer,
            content: _buildEventContent(),
            likes: 124,
            comments: 32,
            isEvent: true,
          ),
          const SizedBox(height: 16),
          _buildFeedCard(
            avatar: Icons.person,
            name: 'Sarah Miller',
            time: '1 day ago',
            badge: 'TIP',
            badgeColor: GymClubTheme.primaryContainer,
            textColor: GymClubTheme.onPrimaryFixed,
            content: _buildTipContent(),
            likes: 89,
            comments: 15,
          ),
          const SizedBox(height: 16),
          _buildFeedCard(
            avatar: Icons.person,
            name: 'Mike Chen',
            time: '1 day ago',
            badge: 'WORKOUT',
            badgeColor: GymClubTheme.surfaceContainerHighest,
            textColor: GymClubTheme.onSurface,
            content: _buildWorkoutContent(),
            likes: 56,
            comments: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildPRContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: GymClubTheme.tertiaryContainer,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'NEW PR!',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: GymClubTheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bench Press',
                          style: TextStyle(
                            color: GymClubTheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '140',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: GymClubTheme.tertiary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'kg',
                              style: TextStyle(
                                color: GymClubTheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: GymClubTheme.tertiaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: GymClubTheme.tertiary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+10kg',
                          style: TextStyle(
                            color: GymClubTheme.tertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymClubTheme.secondaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: GymClubTheme.secondaryContainer.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: GymClubTheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'UPCOMING',
                      style: TextStyle(
                        color: GymClubTheme.onSecondaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.event,
                    color: GymClubTheme.secondary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Saturday Shred',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: GymClubTheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'High-intensity cardio & conditioning session',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildEventInfo(Icons.calendar_today, 'Sat, Mar 22'),
                  const SizedBox(width: 16),
                  _buildEventInfo(Icons.access_time, '08:00'),
                  const SizedBox(width: 16),
                  _buildEventInfo(Icons.people, '14/20 spots'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: GymClubTheme.secondary, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTipContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pro tip for better bench press form:',
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymClubTheme.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: GymClubTheme.primaryContainer.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb,
                color: GymClubTheme.primaryContainer,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Retract your scapulae and maintain a slight arch in your lower back. This creates a stable base and targets chest more effectively.',
                  style: TextStyle(
                    color: GymClubTheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Just finished an intense pull day session! 💪',
          style: TextStyle(
            color: GymClubTheme.onSurface,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWorkoutStat(Icons.fitness_center, '8 exercises'),
                  _buildWorkoutStat(Icons.show_chart, '24,500 lbs'),
                  _buildWorkoutStat(Icons.timer, '62 mins'),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildWorkoutTag('Pull Day'),
                  _buildWorkoutTag('Back'),
                  _buildWorkoutTag('Biceps'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: GymClubTheme.onSurfaceVariant, size: 14),
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

  Widget _buildWorkoutTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: GymClubTheme.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildFeedCard({
    required IconData avatar,
    required String name,
    required String time,
    required String badge,
    required Color badgeColor,
    required Color textColor,
    required Widget content,
    required int likes,
    required int comments,
    bool isEvent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: GymClubTheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  color: GymClubTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.thumb_up, color: GymClubTheme.primary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: GymClubTheme.onSurfaceVariant, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$comments',
                      style: TextStyle(
                        color: GymClubTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.share,
                  color: GymClubTheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
