import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/arabic_digits.dart';

/// الشريط السفلي لشاشة القراءة، مرتّب يمينًا إلى يسار.
class ReadingBottomBar extends StatelessWidget {
  const ReadingBottomBar({
    super.key,
    required this.stopSurahName,
    required this.stopAyahNumber,
    required this.isNight,
    required this.panelColor,
    required this.headingColor,
    required this.onStopAyah,
    required this.onCompleteWird,
    required this.onToggleTheme,
    required this.onExit,
  });

  final String stopSurahName;
  final int stopAyahNumber;
  final bool isNight;
  final Color panelColor;
  final Color headingColor;
  final VoidCallback onStopAyah;
  final VoidCallback onCompleteWird;
  final VoidCallback onToggleTheme;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: panelColor,
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.fromLTRB(6.w, 8.h, 6.w, 8.h),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: _BottomBarAction(
                    icon: Icons.bookmark_rounded,
                    label: AppStrings.stopAyah,
                    caption:
                        '$stopSurahName • ${AppStrings.ayahLabel} ${toArabicDigits(stopAyahNumber)}',
                    color: AppColors.gold,
                    headingColor: headingColor,
                    onTap: onStopAyah,
                  ),
                ),
                Expanded(
                  child: _BottomBarAction(
                    icon: Icons.auto_awesome,
                    label: AppStrings.completeWirdShort,
                    color: AppColors.gold,
                    headingColor: headingColor,
                    onTap: onCompleteWird,
                  ),
                ),
                Expanded(
                  child: _BottomBarAction(
                    icon: isNight
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    label: isNight ? AppStrings.dayMode : AppStrings.nightMode,
                    color: headingColor,
                    headingColor: headingColor,
                    onTap: onToggleTheme,
                  ),
                ),
                Expanded(
                  child: _BottomBarAction(
                    icon: Icons.close_rounded,
                    label: AppStrings.exitReading,
                    color: headingColor,
                    headingColor: headingColor,
                    onTap: onExit,
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

class _BottomBarAction extends StatelessWidget {
  const _BottomBarAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.headingColor,
    required this.onTap,
    this.caption,
  });

  final IconData icon;
  final String label;
  final String? caption;
  final Color color;
  final Color headingColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              SizedBox(height: 4.h),
              Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: headingColor,
                ),
              ),
              if (caption != null) ...[
                SizedBox(height: 2.h),
                Text(
                  caption!,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
