import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final label = isDark ? AppStrings.dayMode : AppStrings.nightMode;
    final icon = isDark
        ? Icons.light_mode_rounded
        : Icons.dark_mode_rounded;

    if (compact) {
      return IconButton(
        tooltip: AppStrings.toggleReadingTheme,
        onPressed: theme.toggle,
        icon: Icon(icon, color: AppColors.heading(context)),
      );
    }

    return Center(
      child: OutlinedButton.icon(
        onPressed: theme.toggle,
        icon: Icon(icon, size: 18.sp, color: AppColors.gold),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.heading(context),
            fontSize: 13.sp,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.heading(context),
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.55)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
      ),
    );
  }
}
