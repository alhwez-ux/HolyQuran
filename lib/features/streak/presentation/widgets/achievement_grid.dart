import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/achievement.dart';

class AchievementGrid extends StatelessWidget {
  const AchievementGrid({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 720
            ? 4
            : width >= 480
                ? 3
                : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: width < 360 ? 0.86 : 0.92,
          ),
          itemBuilder: (context, index) {
            final item = achievements[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.unlocked ? AppColors.surface : AppColors.parchment,
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                border: Border.all(
                  color: item.unlocked
                      ? AppColors.gold.withValues(alpha: 0.55)
                      : AppColors.parchmentDark,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    color: item.unlocked
                        ? AppColors.goldAccent
                        : AppColors.muted,
                    size: 28.sp,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                      color: item.unlocked
                          ? AppColors.primaryGreen
                          : AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.unlocked ? item.subtitle : AppStrings.lockedBadge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.muted),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
