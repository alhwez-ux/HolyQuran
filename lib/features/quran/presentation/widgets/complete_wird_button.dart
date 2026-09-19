import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// زر بارز لإتمام الورد اليومي في أسفل شاشة المصحف.
class CompleteWirdButton extends StatelessWidget {
  const CompleteWirdButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, Color(0xFF3D5A4C)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18.r),
          child: SizedBox(
            width: double.infinity,
            height: 58.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.goldAccent,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    AppStrings.completeWird,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
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
