import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/theme/reading_options.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/ayah.dart';
import 'mushaf_page_view.dart';

/// تقليب صفحات المصحف أفقياً، أو بتمرير رأسي مستمر يتبع حركة الإصبع.
class MushafPager extends StatelessWidget {
  const MushafPager({
    super.key,
    required this.twoPageSpread,
    required this.onPageChanged,
    this.pageController,
    this.scrollController,
    this.currentPage = 1,
    this.scrollDirection = Axis.horizontal,
    this.fullscreen = false,
    this.onToggleFullscreen,
    this.onAyahTap,
  });

  final PageController? pageController;
  final ScrollController? scrollController;
  final int currentPage;
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
    if (vertical) {
      final scroll = scrollController;
      pager = scroll == null
          ? const Center(child: CircularProgressIndicator())
          : _ContinuousVerticalMushaf(
              controller: scroll,
              currentPage: currentPage,
              fullscreen: fullscreen,
              onPageChanged: onPageChanged,
              onAyahTap: onAyahTap,
            );
    } else if (spread) {
      pager = PageView.builder(
        controller: pageController,
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
        controller: pageController,
        scrollDirection: Axis.horizontal,
        itemCount: MushafAssets.totalPages,
        allowImplicitScrolling: true,
        pageSnapping: true,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        onPageChanged: (index) => onPageChanged(index + 1),
        itemBuilder: (context, index) {
          return _pageFrame(
            pageNumber: index + 1,
            fullscreen: fullscreen,
            onAyahTap: onAyahTap,
          );
        },
      );
    }

    return GestureDetector(
      onDoubleTap: onToggleFullscreen,
      child: AnimatedContainer(
        duration: kReadingBackdropAnim,
        curve: Curves.easeInOut,
        color: backdrop.canvas,
        child: pager,
      ),
    );
  }
}

Widget _pageFrame({
  required int pageNumber,
  required bool fullscreen,
  required ValueChanged<Ayah>? onAyahTap,
}) {
  final page = MushafPageView(
    pageNumber: pageNumber,
    fullscreen: fullscreen,
    onAyahTap: onAyahTap,
  );
  if (fullscreen) return page;
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: page,
    ),
  );
}

class _ContinuousVerticalMushaf extends StatefulWidget {
  const _ContinuousVerticalMushaf({
    required this.controller,
    required this.currentPage,
    required this.fullscreen,
    required this.onPageChanged,
    this.onAyahTap,
  });

  final ScrollController controller;
  final int currentPage;
  final bool fullscreen;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Ayah>? onAyahTap;

  @override
  State<_ContinuousVerticalMushaf> createState() =>
      _ContinuousVerticalMushafState();
}

class _ContinuousVerticalMushafState extends State<_ContinuousVerticalMushaf> {
  double? _extent;
  bool _didInitialJump = false;
  int _lastReportedPage = 0;

  @override
  void didUpdateWidget(covariant _ContinuousVerticalMushaf oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _didInitialJump = false;
      _extent = null;
    }
  }

  void _jumpToPage(int page) {
    final controller = widget.controller;
    if (!controller.hasClients) return;
    final extent = controller.position.viewportDimension;
    if (extent <= 0) return;
    final target = ((page - 1) * extent).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    if ((controller.offset - target).abs() < 1) return;
    controller.jumpTo(target);
  }

  void _reportPageFromOffset(double pixels, double extent) {
    if (extent <= 0) return;
    final page = (pixels / extent).round() + 1;
    final bounded = page.clamp(1, MushafAssets.totalPages);
    if (bounded == _lastReportedPage) return;
    _lastReportedPage = bounded;
    widget.onPageChanged(bounded);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = constraints.maxHeight;
        if (extent <= 0) return const SizedBox.shrink();

        final extentChanged = _extent != null && _extent != extent;
        _extent = extent;

        if (!_didInitialJump || extentChanged) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (!_didInitialJump) {
              _didInitialJump = true;
              _lastReportedPage = widget.currentPage;
              _jumpToPage(widget.currentPage);
              return;
            }
            _jumpToPage(widget.currentPage);
          });
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis != Axis.vertical) return false;
            if (notification is ScrollUpdateNotification ||
                notification is ScrollEndNotification) {
              _reportPageFromOffset(
                notification.metrics.pixels,
                notification.metrics.viewportDimension,
              );
            }
            return false;
          },
          child: ListView.builder(
            controller: widget.controller,
            primary: false,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemExtent: extent,
            itemCount: MushafAssets.totalPages,
            cacheExtent: extent,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              return _pageFrame(
                pageNumber: index + 1,
                fullscreen: widget.fullscreen,
                onAyahTap: widget.onAyahTap,
              );
            },
          ),
        );
      },
    );
  }
}
