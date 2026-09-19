import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mushaf_assets.dart';
import 'mushaf_text_page.dart';

/// صفحة مصحف مجمع الملك فهد من الأصول المحلية.
class MushafPageView extends StatelessWidget {
  const MushafPageView({super.key, required this.pageNumber});

  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.mushafPaper,
      child: Image.asset(
        MushafAssets.pagePath(pageNumber),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => MushafTextPage(pageNumber: pageNumber),
      ),
    );
  }
}
