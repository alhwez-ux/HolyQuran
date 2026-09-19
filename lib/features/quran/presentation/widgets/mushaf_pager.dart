import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mushaf_assets.dart';
import 'mushaf_page_view.dart';

/// تقليب صفحات المصحف: صفحة واحدة للهاتف/التابلت، وصفحتان للحاسوب.
class MushafPager extends StatelessWidget {
  const MushafPager({
    super.key,
    required this.controller,
    required this.twoPageSpread,
    required this.onPageChanged,
  });

  final PageController controller;
  final bool twoPageSpread;
  final ValueChanged<int> onPageChanged;

  static int spreadCount(int totalPages) => ((totalPages + 1) ~/ 2);

  static int spreadIndexForPage(int page) => ((page - 1) ~/ 2);

  static int pageForSpreadIndex(int index) => index * 2 + 1;

  @override
  Widget build(BuildContext context) {
    if (twoPageSpread) {
    return PageView.builder(
      controller: controller,
      itemCount: spreadCount(MushafAssets.totalPages),
      allowImplicitScrolling: true,
      pageSnapping: true,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      onPageChanged: (index) => onPageChanged(pageForSpreadIndex(index)),
        itemBuilder: (context, index) {
          final rightPage = pageForSpreadIndex(index);
          final leftPage = rightPage + 1;
          return ColoredBox(
            color: AppColors.mushafPaper,
            child: Row(
              children: [
                Expanded(child: MushafPageView(pageNumber: rightPage)),
                if (leftPage <= MushafAssets.totalPages)
                  Expanded(child: MushafPageView(pageNumber: leftPage)),
              ],
            ),
          );
        },
      );
    }

    return PageView.builder(
      controller: controller,
      itemCount: MushafAssets.totalPages,
      allowImplicitScrolling: true,
      pageSnapping: true,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      onPageChanged: (index) => onPageChanged(index + 1),
      itemBuilder: (context, index) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: MushafPageView(pageNumber: index + 1),
          ),
        );
      },
    );
  }
}
