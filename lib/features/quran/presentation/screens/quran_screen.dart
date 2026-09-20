import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/theme/reading_options.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/arabic_digits.dart';
import '../../../../core/utils/responsive.dart';
import '../../../reward/presentation/pages/prophetic_reward_dialog.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';
import '../widgets/mushaf_pager.dart';
import '../widgets/reading_bottom_bar.dart';
import '../widgets/reading_settings_sheet.dart';
import '../widgets/surah_index_pane.dart';

/// شاشة عرض المصحف: خلفيات القراءة، آية التوقف، ملء الشاشة، وتقليب الصفحات.
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, this.initialSurah});

  final Surah? initialSurah;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController? _pageController;
  ScrollController? _scrollController;
  late int _page;
  bool? _twoPageSpread;
  Axis? _axis;
  bool _fullscreen = false;

  bool get _pagerReady =>
      _axis == Axis.vertical ? _scrollController != null : _pageController != null;

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
    final settings = context.watch<ThemeProvider>();
    final axis = settings.pageTurn.isVertical ? Axis.vertical : Axis.horizontal;
    final spread = !settings.pageTurn.isVertical &&
        !_fullscreen &&
        Responsive.usesTwoPageSpread(context);
    _syncController(spread: spread, axis: axis);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  void _syncController({required bool spread, required Axis axis}) {
    if (_twoPageSpread == spread &&
        _axis == axis &&
        (_axis == Axis.vertical
            ? _scrollController != null
            : _pageController != null)) {
      return;
    }
    final oldPageController = _pageController;
    final oldScrollController = _scrollController;
    _pageController = null;
    _scrollController = null;
    _twoPageSpread = spread;
    _axis = axis;
    if (axis == Axis.vertical) {
      _scrollController = ScrollController();
    } else {
      _pageController = PageController(
        initialPage: spread
            ? MushafPager.spreadIndexForPage(_page)
            : _page - 1,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldPageController?.dispose();
      oldScrollController?.dispose();
    });
  }

  Future<void> _scrollToVerticalPage(int page, {required bool animate}) async {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;
    final extent = controller.position.viewportDimension;
    if (extent <= 0) return;
    final target = ((page - 1) * extent).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    if (animate) {
      await controller.animateTo(
        target,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      controller.jumpTo(target);
    }
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
    final bounded = page.clamp(1, MushafAssets.totalPages);
    if (_axis == Axis.vertical) {
      await _scrollToVerticalPage(bounded, animate: true);
      return;
    }
    final controller = _pageController;
    if (controller == null || !controller.hasClients) return;
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
    if (_axis == Axis.vertical) {
      await _scrollToVerticalPage(page, animate: false);
    } else {
      final controller = _pageController;
      final spread = _twoPageSpread ?? false;
      if (controller != null && controller.hasClients) {
        controller.jumpToPage(
          spread ? MushafPager.spreadIndexForPage(page) : page - 1,
        );
      }
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

  void _jumpToStopAyah() {
    final page = context.read<QuranProvider>().progress.pageNumber;
    _goToPage(page);
  }

  void _exitReading() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _toggleFullscreen() async {
    final next = !_fullscreen;
    setState(() {
      _fullscreen = next;
      final settings = context.read<ThemeProvider>();
      final axis =
          settings.pageTurn.isVertical ? Axis.vertical : Axis.horizontal;
      final spread = !next &&
          !settings.pageTurn.isVertical &&
          Responsive.usesTwoPageSpread(context);
      _syncController(spread: spread, axis: axis);
    });
    await SystemChrome.setEnabledSystemUIMode(
      next ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  Future<void> _onAyahTapped(Ayah ayah) async {
    await HapticFeedback.selectionClick();
    await context.read<QuranProvider>().saveStopAyah(ayah);
    if (!mounted) return;
    final surah =
        context.read<QuranProvider>().surahByNumber(ayah.surahNumber);
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        backgroundColor: AppColors.primaryGreen,
        content: Text(
          '${AppStrings.stopAyahSaved}: ${surah.nameAr} • ${AppStrings.ayahLabel} ${toArabicDigits(ayah.number)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _openSettings() {
    ReadingSettingsSheet.show(
      context: context,
      fullscreen: _fullscreen,
      onToggleFullscreen: _toggleFullscreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final settings = context.watch<ThemeProvider>();
    final backdrop = settings.backdrop;
    final segments = quran.segmentsOnPage(_page);
    final surahName = segments.isEmpty
        ? AppStrings.mushaf
        : quran.surahByNumber(segments.first.surahNumber).nameAr;
    final selectedSurah = segments.isEmpty
        ? quran.progress.surahNumber
        : segments.first.surahNumber;
    final fontScale = _fullscreen ? 1.22 : 1.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final split = !_fullscreen &&
            !settings.pageTurn.isVertical &&
            constraints.maxWidth >= 600;
        final spread = !_fullscreen &&
            !settings.pageTurn.isVertical &&
            constraints.maxWidth >= 1024;
        final indexWidth = Responsive.indexPaneWidth(constraints.maxWidth);
        return AnimatedContainer(
          duration: kReadingBackdropAnim,
          curve: Curves.easeInOut,
          color: backdrop.canvas,
          child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: _fullscreen
              ? null
              : AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: backdrop.heading,
                  elevation: 0,
                  flexibleSpace: AnimatedContainer(
                    duration: kReadingBackdropAnim,
                    curve: Curves.easeInOut,
                    color: backdrop.panel,
                  ),
                  title: Text(
                    '$surahName  •  ${AppStrings.pageLabel} ${toArabicDigits(_page)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp * fontScale,
                      color: backdrop.heading,
                    ),
                  ),
                  actions: [
                    IconButton(
                      tooltip: AppStrings.enterFullscreen,
                      onPressed: _toggleFullscreen,
                      icon: Icon(
                        Icons.fullscreen_rounded,
                        color: backdrop.heading,
                      ),
                    ),
                    IconButton(
                      tooltip: AppStrings.readingSettings,
                      onPressed: _openSettings,
                      icon: Icon(
                        Icons.palette_rounded,
                        color: backdrop.heading,
                      ),
                    ),
                    if (!split)
                      IconButton(
                        tooltip: AppStrings.mushafIndex,
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        icon: Icon(
                          Icons.list_alt_rounded,
                          color: backdrop.heading,
                        ),
                      ),
                  ],
                ),
          drawer: split
              ? null
              : Drawer(
                  backgroundColor: backdrop.panel,
                  child: SafeArea(
                    child: SurahIndexPane(
                      selectedSurahNumber: selectedSurah,
                      onSelect: _openSurah,
                    ),
                  ),
                ),
          body: !_pagerReady
              ? const Center(child: CircularProgressIndicator())
              : split
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
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: backdrop.panel,
                        ),
                        Expanded(
                          child: MushafPager(
                            pageController: _pageController,
                            scrollController: _scrollController,
                            currentPage: _page,
                            twoPageSpread: spread,
                            scrollDirection: settings.pageTurn.isVertical
                                ? Axis.vertical
                                : Axis.horizontal,
                            fullscreen: _fullscreen,
                            onToggleFullscreen: _toggleFullscreen,
                            onAyahTap: _onAyahTapped,
                            onPageChanged: _persistPage,
                          ),
                        ),
                      ],
                    )
                  : MushafPager(
                      pageController: _pageController,
                      scrollController: _scrollController,
                      currentPage: _page,
                      twoPageSpread: false,
                      scrollDirection: settings.pageTurn.isVertical
                          ? Axis.vertical
                          : Axis.horizontal,
                      fullscreen: _fullscreen,
                      onToggleFullscreen: _toggleFullscreen,
                      onAyahTap: _onAyahTapped,
                      onPageChanged: _persistPage,
                    ),
          bottomNavigationBar: ReadingBottomBar(
            stopSurahName:
                quran.surahByNumber(quran.progress.surahNumber).nameAr,
            stopAyahNumber: quran.progress.ayahNumber,
            isNight: settings.backdrop.isNight,
            panelColor: backdrop.panel,
            headingColor: backdrop.heading,
            onStopAyah: _jumpToStopAyah,
            onCompleteWird: _completeWird,
            onToggleTheme: settings.toggle,
            onExit: _exitReading,
          ),
          floatingActionButton: _fullscreen
              ? FloatingActionButton.small(
                  tooltip: AppStrings.readingSettings,
                  backgroundColor: backdrop.panel,
                  foregroundColor: backdrop.heading,
                  onPressed: _openSettings,
                  child: const Icon(Icons.tune_rounded),
                )
              : null,
        ),
        );
      },
    );
  }
}
