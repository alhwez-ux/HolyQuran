import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../../domain/entities/ayah.dart';

class AyahView extends StatelessWidget {
  const AyahView({
    super.key,
    required this.ayah,
    required this.highlighted,
    required this.onTap,
  });

  final Ayah ayah;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: highlighted
              ? AppColors.gold.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: ayah.text,
                style: TextStyle(
                  fontSize: 26.sp,
                  height: 2.05,
                  color: AppColors.ink,
                ),
              ),
              TextSpan(
                text: '  ﴿${toArabicDigits(ayah.number)}﴾',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
