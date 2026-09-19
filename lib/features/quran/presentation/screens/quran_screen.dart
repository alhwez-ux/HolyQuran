import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../../../../core/utils/responsive.dart';
import '../../../reward/presentation/pages/prophetic_reward_dialog.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';
import '../widgets/complete_wird_button.dart';
import '../widgets/mushaf_pager.dart';
import '../widgets/surah_index_pane.dart';

/// شاشة عرض المصحف الرئيسية:
/// هاتف = صفحة واحدة بملء الشاشة،
/// تابلت = الفهرس بجانب الصفحة،
/// حاسوب = الفهرس مع صفحتين متقابلتين،
/// مع تقليب سلس وحفظ آخر صفحة في Hive.
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, this.initialSurah});

  final Surah? initialSurah;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController? _controller;
  late int _page;
  bool? _twoPageSpread;

  @override
  void initState() {
    super.initState();
    final quran = context.read<QuranProvider>();
    final restored = widget.initialSurah != null
        ? quran.firstPageOf(widget.initialSurah!.number)
        : quran.currentPage;
    _page = restored.clamp(1, MushafAssets.totalPages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quran.savePage(_page);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final spread = Responsive.usesTwoPageSpread(context);
    if (_twoPageSpread == spread && _controller != null) return;
    _controller?.dispose();
    _twoPageSpread = spread;
    _controller = PageController(
      initialPage: spread
          ? MushafPager.spreadIndexForPage(_page)
          : _page - 1,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _persistPage(int page) async {
    final bounded = page.clamp(1, MushafAssets.totalPages);
    if (_page != bounded) {
      setState(() => _page = bounded);
    } else {
      _page = bounded;
    }
    await context.read<QuranProvider>().savePage(bounded);
    _precacheAround(bounded);
  }

  void _precacheAround(int page) {
    for (final nearby in [page - 1, page + 1, page + 2]) {
      if (nearby < 1 || nearby > MushafAssets.totalPages) continue;
      precacheImage(AssetImage(MushafAssets.pagePath(nearby)), context);
    }
  }

  Future<void> _goToPage(int page) async {
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    final bounded = page.clamp(1, MushafAssets.totalPages);
    final spread = _twoPageSpread ?? false;
    await controller.animateToPage(
      spread ? MushafPager.spreadIndexForPage(bounded) : bounded - 1,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openSurah(Surah surah) async {
    final quran = context.read<QuranProvider>();
    final page = quran.firstPageOf(surah.number);
    final controller = _controller;
    final spread = _twoPageSpread ?? false;
    if (controller != null && controller.hasClients) {
      controller.jumpToPage(
        spread ? MushafPager.spreadIndexForPage(page) : page - 1,
      );
    }
    await _persistPage(page);
    if (!mounted) return;
    if (Responsive.isPhone(context)) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _completeWird() {
    context.read<QuranProvider>().savePage(_page);
    PropheticRewardDialog.show(context);
  }

  int get _step => (_twoPageSpread ?? false) ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final segments = quran.segmentsOnPage(_page);
    final surahName = segments.isEmpty
        ? AppStrings.mushaf
        : quran.surahByNumber(segments.first.surahNumber).nameAr;
    final selectedSurah = segments.isEmpty
        ? quran.progress.surahNumber
        : segments.first.surahNumber;

    return LayoutBuilder(
      builder: (context, constraints) {
        final split = constraints.maxWidth >= 600;
        final spread = constraints.maxWidth >= 1024;
        final indexWidth = Responsive.indexPaneWidth(constraints.maxWidth);
        final controller = _controller;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.mushafPaper,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundLight,
            title: Text(
              '$surahName  •  ${AppStrings.pageLabel} ${toArabicDigits(_page)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
            ),
            actions: [
              if (!split)
                IconButton(
                  tooltip: AppStrings.mushafIndex,
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.list_alt_rounded),
                ),
            ],
          ),
          drawer: split
              ? null
              : Drawer(
                  backgroundColor: AppColors.parchment,
                  child: SafeArea(
                    child: SurahIndexPane(
                      selectedSurahNumber: selectedSurah,
                      onSelect: _openSurah,
                    ),
                  ),
                ),
          body: controller == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: split
                          ? Row(
                              children: [
                                SizedBox(
                                  width: indexWidth,
                                  child: SurahIndexPane(
                                    compact: true,
                                    selectedSurahNumber: selectedSurah,
                                    onSelect: _openSurah,
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                  color: AppColors.parchmentDark,
                                ),
                                Expanded(
                                  child: MushafPager(
                                    controller: controller,
                                    twoPageSpread: spread,
                                    onPageChanged: _persistPage,
                                  ),
                                ),
                              ],
                            )
                          : MushafPager(
                              controller: controller,
                              twoPageSpread: false,
                              onPageChanged: _persistPage,
                            ),
                    ),
                    _MushafControls(
                      page: _page,
                      step: _step,
                      onPrevious: _page <= 1
                          ? null
                          : () => _goToPage(_page - _step),
                      onNext: _page >= MushafAssets.totalPages
                          ? null
                          : () => _goToPage(_page + _step),
                      onCompleteWird: _completeWird,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _MushafControls extends StatelessWidget {
  const _MushafControls({
    required this.page,
    required this.step,
    required this.onPrevious,
    required this.onNext,
    required this.onCompleteWird,
  });

  final int page;
  final int step;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onCompleteWird;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.backgroundLight,
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: AppStrings.previousPage,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
                Expanded(
                  child: Text(
                    '${toArabicDigits(page)} / ${toArabicDigits(MushafAssets.totalPages)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: AppStrings.nextPage,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            CompleteWirdButton(onPressed: onCompleteWird),
          ],
        ),
      ),
    );
  }
}
