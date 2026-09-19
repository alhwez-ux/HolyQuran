import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/hadith.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({super.key, required this.hadith});

  final Hadith hadith;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, color: AppColors.gold, size: 32.sp),
          if (hadith.title.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              hadith.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            hadith.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              height: 1.85,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            hadith.narrator,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${AppStrings.hadithSource}: ${hadith.source}',
            style: TextStyle(fontSize: 12.sp, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
