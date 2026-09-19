import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quran_khatma/core/constants/app_strings.dart';
import 'package:quran_khatma/core/constants/mushaf_assets.dart';
import 'package:quran_khatma/core/utils/arabic_digits.dart';
import 'package:quran_khatma/features/quran/presentation/widgets/mushaf_pager.dart';

void main() {
  testWidgets('يعرض اسم التطبيق', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text(AppStrings.appName)),
      ),
    );

    expect(find.text('ختم القرآن'), findsOneWidget);
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
}
