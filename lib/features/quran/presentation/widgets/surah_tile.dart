import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/surah.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.surah,
    required this.onTap,
    this.selected = false,
    this.compact = false,
  });

  final Surah surah;
  final VoidCallback onTap;
  final bool selected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: AppColors.isDark(context) ? 0.22 : 0.08)
          : AppColors.card(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10.w : 14.w,
            vertical: compact ? 8.h : 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            border: Border.all(
              color: selected ? AppColors.gold : AppColors.parchmentDark,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              _NumberBadge(number: surah.number, compact: compact),
              SizedBox(width: compact ? 10.w : 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 18.sp : 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${surah.ayahCount} ${AppStrings.ayahs}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.panel(context),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  surah.isMakki ? AppStrings.makki : AppStrings.madani,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.compact});

  final int number;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = (compact ? 36.w : 42.w).clamp(32.0, 44.0);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: compact ? 12.sp : 14.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
