import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quran_khatma/core/constants/app_strings.dart';
import 'package:quran_khatma/core/constants/mushaf_assets.dart';
import 'package:quran_khatma/core/utils/arabic_digits.dart';
import 'package:quran_khatma/features/quran/domain/ayah_locator.dart';
import 'package:quran_khatma/features/quran/presentation/widgets/mushaf_pager.dart';
import 'package:quran_khatma/features/quran/presentation/widgets/reading_bottom_bar.dart';

void main() {
  testWidgets('يعرض اسم التطبيق', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text(AppStrings.appName)),
      ),
    );

    expect(find.text('ختمة القرآن الكريم'), findsOneWidget);
  });

  test('مسارات صفحات المصحف محلية ومتسلسلة', () {
    expect(MushafAssets.totalPages, 604);
    expect(MushafAssets.pagePath(1), 'assets/mushaf/pages/001.png');
    expect(MushafAssets.pagePath(604), 'assets/mushaf/pages/604.png');
  });

  test('الأرقام العربية لترقيم الصفحات', () {
    expect(toArabicDigits(1), '١');
    expect(toArabicDigits(604), '٦٠٤');
  });

  test('تقليب الصفحات المزدوجة يحافظ على رقم الصفحة الصحيحة', () {
    expect(MushafPager.spreadIndexForPage(1), 0);
    expect(MushafPager.spreadIndexForPage(2), 0);
    expect(MushafPager.spreadIndexForPage(3), 1);
    expect(MushafPager.pageForSpreadIndex(0), 1);
    expect(MushafPager.pageForSpreadIndex(1), 3);
    expect(MushafPager.spreadCount(604), 302);
  });

  test('الفاتحة وبداية البقرة تستخدمان التخطيط المتوسط', () {
    expect(MushafAssets.usesCenteredLayout(1), isTrue);
    expect(MushafAssets.usesCenteredLayout(2), isTrue);
    expect(MushafAssets.usesCenteredLayout(3), isFalse);
  });

  test('لمس الصفحة يحدد رقم الآية حسب الموضع الرأسي', () {
    expect(
      ayahIndexForFraction(ayahCount: 10, fraction: 0),
      0,
    );
    expect(
      ayahIndexForFraction(ayahCount: 10, fraction: 0.25),
      2,
    );
    expect(
      ayahIndexForFraction(ayahCount: 10, fraction: 0.99),
      9,
    );
    expect(
      ayahIndexForFraction(ayahCount: 7, fraction: 0.5, centered: true),
      inInclusiveRange(2, 4),
    );
  });

  testWidgets('الشريط السفلي يعرض الأزرار الأربعة بالترتيب', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ReadingBottomBar(
              stopSurahName: 'البقرة',
              stopAyahNumber: 15,
              isNight: false,
              panelColor: const Color(0xFFECE7DC),
              headingColor: const Color(0xFF2B3F35),
              onStopAyah: () {},
              onCompleteWird: () {},
              onToggleTheme: () {},
              onExit: () {},
            ),
          ),
        ),
      ),
    );

    final labels = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .whereType<String>()
        .toList();

    expect(labels, containsAllInOrder([
      AppStrings.stopAyah,
      AppStrings.completeWirdShort,
      AppStrings.nightMode,
      AppStrings.exitReading,
    ]));
    expect(find.textContaining('البقرة'), findsOneWidget);
    expect(find.textContaining(toArabicDigits(15)), findsOneWidget);
  });
}
