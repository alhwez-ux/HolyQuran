import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/ayah.dart';
import '../providers/quran_provider.dart';

/// عرض نصّي لصفحة المصحف إن تعذّر تحميل الصورة المحلية.
class MushafTextPage extends StatelessWidget {
  const MushafTextPage({
    super.key,
    required this.pageNumber,
    this.fullscreen = false,
    this.onAyahTap,
  });

  final int pageNumber;
  final bool fullscreen;
  final ValueChanged<Ayah>? onAyahTap;

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final backdrop = context.watch<ThemeProvider>().backdrop;
    final segments = quran.segmentsOnPage(pageNumber);
    final ayahs = quran.ayahsOnPage(pageNumber);
    final centered = MushafAssets.usesCenteredLayout(pageNumber);
    final scale = fullscreen ? 1.28 : 1.0;

    return AnimatedContainer(
      duration: kReadingBackdropAnim,
      curve: Curves.easeInOut,
      color: backdrop.canvas,
      child: Padding(
        padding: Responsive.mushafPageInsets(
          context,
          fullscreen: fullscreen,
        ),
        child: Column(
          children: [
            if (segments.isNotEmpty)
              Text(
                quran.surahByNumber(segments.first.surahNumber).nameAr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp * scale,
                  fontWeight: FontWeight.w800,
                  color: backdrop.heading,
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
                            fontSize: 24.sp * scale,
                            height: 2.15,
                            backgroundColor: quran.isStopAyah(ayah)
                                ? AppColors.gold.withValues(alpha: 0.22)
                                : null,
                            color: backdrop.body,
                          ),
                        ),
                        TextSpan(
                          text: ' ﴿${toArabicDigits(ayah.number)}﴾ ',
                          style: TextStyle(
                            fontSize: 16.sp * scale,
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.w700,
                            backgroundColor: quran.isStopAyah(ayah)
                                ? AppColors.gold.withValues(alpha: 0.22)
                                : null,
                          ),
                        ),
                      ],
                    ],
                  ),
                  textAlign: centered ? TextAlign.center : TextAlign.justify,
                ),
              ),
            ),
            Text(
              '${AppStrings.pageLabel} ${toArabicDigits(pageNumber)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp * scale,
                color: backdrop.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
