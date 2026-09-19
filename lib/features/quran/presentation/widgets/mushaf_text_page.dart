import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../providers/quran_provider.dart';

/// عرض نصّي لصفحة المصحف إن تعذّر تحميل الصورة المحلية.
class MushafTextPage extends StatelessWidget {
  const MushafTextPage({super.key, required this.pageNumber});

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final segments = quran.segmentsOnPage(pageNumber);
    final ayahs = quran.ayahsOnPage(pageNumber);

    return ColoredBox(
      color: AppColors.mushafPaper,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          children: [
            if (segments.isNotEmpty)
              Text(
                quran.surahByNumber(segments.first.surahNumber).nameAr,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            SizedBox(height: 12.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text.rich(
                  TextSpan(
                    children: [
                      for (final ayah in ayahs) ...[
                        TextSpan(
                          text: ayah.text,
                          style: TextStyle(
                            fontSize: 24.sp,
                            height: 2.1,
                            color: AppColors.ink,
                          ),
                        ),
                        TextSpan(
                          text: ' ﴿${toArabicDigits(ayah.number)}﴾ ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Text(
              '${AppStrings.pageLabel} ${toArabicDigits(pageNumber)}',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
