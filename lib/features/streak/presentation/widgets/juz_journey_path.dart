import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/arabic_digits.dart';

/// مسار بصري لـ 30 جزءاً من الختمة.
class JuzJourneyPath extends StatelessWidget {
  const JuzJourneyPath({
    super.key,
    required this.completedJuz,
    required this.currentJuz,
  });

  final int completedJuz;
  final int currentJuz;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.center,
      children: [
        for (var juz = 1; juz <= 30; juz++)
          _JuzNode(
            juz: juz,
            completed: juz <= completedJuz,
            current: juz == currentJuz && completedJuz < 30,
          ),
      ],
    );
  }
}

class _JuzNode extends StatelessWidget {
  const _JuzNode({
    required this.juz,
    required this.completed,
    required this.current,
  });

  final int juz;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final fill = completed
        ? AppColors.goldAccent
        : current
            ? AppColors.primaryGreen
            : AppColors.parchmentDark;
    final fg = completed || current ? AppColors.white : AppColors.muted;

    final size = (48.w).clamp(40.0, 52.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: current ? AppColors.goldSoft : Colors.transparent,
          width: current ? 2.4 : 0,
        ),
        boxShadow: completed
            ? [
                BoxShadow(
                  color: AppColors.goldAccent.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Text(
        toArabicDigits(juz),
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
