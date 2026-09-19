import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../quran/domain/entities/surah.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../../../quran/presentation/providers/quran_provider.dart';
import '../../../reward/presentation/pages/prophetic_reward_dialog.dart';
import '../../../reward/presentation/providers/reward_provider.dart';
import '../../../streak/presentation/pages/journey_screen.dart';
import '../../../streak/presentation/providers/streak_provider.dart';
import '../../../streak/presentation/widgets/streak_badge.dart';
import '../widgets/install_app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openLastReading(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
    );
  }

  Future<void> _openTreasure(BuildContext context) async {
    final streak = context.read<StreakProvider>();
    if (!streak.readToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.chestLocked)),
      );
      return;
    }
    PropheticRewardDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final streak = context.watch<StreakProvider>();
    final reward = context.watch<RewardProvider>();
    final last = quran.lastSurah;
    final started = quran.progress.hasStarted;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: ListView(
              padding: Responsive.pagePadding(context),
              children: [
                SizedBox(height: 8.h),
                Text(
                  AppStrings.welcomeAbuNayef,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  AppStrings.appTagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.muted,
                  ),
                ),
                SizedBox(height: 24.h),
                StreakBadge(
                  streak: streak.streak,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JourneyScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                _ContinueCard(
                  surah: last,
                  started: started,
                  onTap: () => _openLastReading(context),
                ),
                SizedBox(height: 14.h),
                _HomeActions(
                  streak: streak,
                  reward: reward,
                  onOpenMushaf: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const QuranScreen(),
                      ),
                    );
                  },
                  onOpenTreasure: () => _openTreasure(context),
                ),
                SizedBox(height: 14.h),
                const InstallAppButton(),
                SizedBox(height: 28.h),
                Text(
                  AppStrings.keepGoing,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.surah,
    required this.started,
    required this.onTap,
  });

  final Surah? surah;
  final bool started;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = !started || surah == null
        ? AppStrings.startReading
        : '${AppStrings.continueReading} • ${surah!.nameAr}';

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.gold,
                size: 36.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (started && surah != null)
                      Text(
                        '${AppStrings.lastPosition}: ${AppStrings.pageLabel} ${context.read<QuranProvider>().progress.pageNumber}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left_rounded, color: AppColors.gold, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeActions extends StatelessWidget {
  const _HomeActions({
    required this.streak,
    required this.reward,
    required this.onOpenMushaf,
    required this.onOpenTreasure,
  });

  final StreakProvider streak;
  final RewardProvider reward;
  final VoidCallback onOpenMushaf;
  final VoidCallback onOpenTreasure;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ActionCard(
        icon: Icons.menu_book_rounded,
        title: AppStrings.mushaf,
        subtitle: AppStrings.mushafSubtitle,
        onTap: onOpenMushaf,
      ),
      _ActionCard(
        icon: Icons.inventory_2_rounded,
        title: AppStrings.treasure,
        subtitle: streak.readToday
            ? (reward.canOpen
                ? AppStrings.chestReady
                : AppStrings.chestOpened)
            : AppStrings.treasureSubtitle,
        highlight: streak.readToday && reward.canOpen,
        onTap: onOpenTreasure,
      ),
    ];

    if (Responsive.stackHomeActions(context)) {
      return Column(
        children: [
          cards[0],
          SizedBox(height: 12.h),
          cards[1],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: cards[0]),
        SizedBox(width: 12.w),
        Expanded(child: cards[1]),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 132),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(
              color: highlight ? AppColors.gold : AppColors.parchmentDark,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: highlight ? AppColors.goldSoft : AppColors.primary,
                size: 30.sp,
              ),
              SizedBox(height: 18.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                  color: highlight ? AppColors.white : AppColors.primary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: highlight
                      ? AppColors.white.withValues(alpha: 0.8)
                      : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
