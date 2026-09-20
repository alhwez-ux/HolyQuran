import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../domain/entities/streak.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak, this.onTap});

  final Streak streak;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final daysLabel =
        streak.current == 1 ? AppStrings.streakDay : AppStrings.streakDays;
    final today = AppDateUtils.isToday(streak.lastReadDate);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: (64.w).clamp(48.0, 72.0),
                height: (64.w).clamp(48.0, 72.0),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldSoft, width: 1.4),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.goldSoft,
                  size: 34.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.streakTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.goldSoft,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${streak.current} $daysLabel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                today
                    ? AppStrings.wirdDone
                    : '${AppStrings.longestStreak}: ${streak.longest}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.82),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
