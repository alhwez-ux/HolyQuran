import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../../../../core/utils/responsive.dart';
import '../../../quran/presentation/providers/quran_provider.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../models/achievement.dart';
import '../providers/streak_provider.dart';
import '../widgets/achievement_grid.dart';
import '../widgets/juz_journey_path.dart';
import '../widgets/streak_badge.dart';

/// شاشة الإنجازات ورحلة الختمة: السلسلة، الأجزاء، الأوسمة، والنقاط من Hive.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final streak = context.watch<StreakProvider>();
    final completed = quran.completedJuzCount;
    final currentJuz = quran.currentJuz.clamp(1, 30);
    final points = quran.khatmaPoints(streakDays: streak.streak.current);
    final progress = completed / 30;
    final achievements = Achievement.fromProgress(
      streakDays: streak.streak.current,
      longestStreak: streak.streak.longest,
      completedJuz: completed,
      started: quran.progress.hasStarted || streak.streak.current > 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.journeyTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.maxContentWidth(context),
          ),
          child: ListView(
            padding: Responsive.pagePadding(context),
            children: [
              Text(
                AppStrings.journeySubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 14.sp),
              ),
              SizedBox(height: 18.h),
              StreakBadge(streak: streak.streak),
              SizedBox(height: 14.h),
              _PointsCard(points: points, completed: completed),
              SizedBox(height: 18.h),
              Text(
                AppStrings.juzPath,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${toArabicDigits(completed)} ${AppStrings.ofThirtyJuz}',
                style: TextStyle(color: AppColors.muted, fontSize: 13.sp),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10.h,
                  backgroundColor: AppColors.parchmentDark,
                  color: AppColors.goldAccent,
                ),
              ),
              SizedBox(height: 16.h),
              JuzJourneyPath(
                completedJuz: completed,
                currentJuz: currentJuz,
              ),
              SizedBox(height: 22.h),
              Text(
                AppStrings.badges,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: 12.h),
              AchievementGrid(achievements: achievements),
              SizedBox(height: 20.h),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const QuranScreen(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text(AppStrings.continueReading),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.points, required this.completed});

  final int points;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: (56.w).clamp(44.0, 64.0),
            height: (56.w).clamp(44.0, 64.0),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.stars_rounded, color: AppColors.gold, size: 30.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.points,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  toArabicDigits(points),
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${toArabicDigits(completed)}/٣٠',
            style: TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
