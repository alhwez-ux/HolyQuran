import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/theme/reading_options.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/ayah.dart';
import 'mushaf_page_view.dart';

/// تقليب صفحات المصحف أفقياً أو بالتمرير الرأسي من الأسفل للأعلى.
class MushafPager extends StatelessWidget {
  const MushafPager({
    super.key,
    required this.controller,
    required this.twoPageSpread,
    required this.onPageChanged,
    this.scrollDirection = Axis.horizontal,
    this.fullscreen = false,
    this.onToggleFullscreen,
    this.onAyahTap,
  });

  final PageController controller;
  final bool twoPageSpread;
  final ValueChanged<int> onPageChanged;
  final Axis scrollDirection;
  final bool fullscreen;
  final VoidCallback? onToggleFullscreen;
  final ValueChanged<Ayah>? onAyahTap;

  static int spreadCount(int totalPages) => ((totalPages + 1) ~/ 2);

  static int spreadIndexForPage(int page) => ((page - 1) ~/ 2);

  static int pageForSpreadIndex(int index) => index * 2 + 1;

  @override
  Widget build(BuildContext context) {
    final backdrop = context.watch<ThemeProvider>().backdrop;
    final vertical = scrollDirection == Axis.vertical;
    final spread = twoPageSpread && !vertical;

    Widget pager;
    if (spread) {
      pager = PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
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
            color: backdrop.canvas,
            child: Row(
              children: [
                Expanded(
                  child: MushafPageView(
                    pageNumber: rightPage,
                    fullscreen: fullscreen,
                    onAyahTap: onAyahTap,
                  ),
                ),
                if (leftPage <= MushafAssets.totalPages)
                  Expanded(
                    child: MushafPageView(
                      pageNumber: leftPage,
                      fullscreen: fullscreen,
                      onAyahTap: onAyahTap,
                    ),
                  ),
              ],
            ),
          );
        },
      );
    } else {
      pager = PageView.builder(
        controller: controller,
        scrollDirection: scrollDirection,
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
              constraints: BoxConstraints(
                maxWidth: fullscreen ? 920 : 720,
              ),
              child: MushafPageView(
                pageNumber: index + 1,
                fullscreen: fullscreen,
                onAyahTap: onAyahTap,
              ),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onDoubleTap: onToggleFullscreen,
      child: ColoredBox(color: backdrop.canvas, child: pager),
    );
  }
}
