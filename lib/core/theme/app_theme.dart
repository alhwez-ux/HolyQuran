import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Amiri',
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.ink,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.parchment,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: TextStyle(color: AppColors.muted, fontSize: 14.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          borderSide: const BorderSide(color: AppColors.parchmentDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          borderSide: const BorderSide(color: AppColors.parchmentDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
