import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/hadith.dart';

/// بطاقة قابلة للمشاركة تُلتقط كصورة عند الضغط على المشاركة.
class ShareableHadithCard extends StatelessWidget {
  const ShareableHadithCard({
    super.key,
    required this.cardKey,
    required this.hadith,
  });

  final GlobalKey cardKey;
  final Hadith hadith;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: cardKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        width: double.infinity,
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F3D3A), Color(0xFF163F2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: AppColors.goldSoft, width: 1.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.goldSoft,
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Container(height: 1.h, width: 72.w, color: AppColors.gold),
            SizedBox(height: 18.h),
            if (hadith.title.isNotEmpty) ...[
              Text(
                hadith.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.goldSoft,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 12.h),
            ],
            Text(
              hadith.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22.sp,
                height: 1.9,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              hadith.narrator,
              style: TextStyle(
                color: AppColors.goldSoft,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              hadith.source,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
