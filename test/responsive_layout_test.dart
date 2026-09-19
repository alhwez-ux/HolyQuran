import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:quran_khatma/core/constants/mushaf_assets.dart';
import 'package:quran_khatma/core/database/hive_boxes.dart';
import 'package:quran_khatma/core/utils/responsive.dart';
import 'package:quran_khatma/features/home/presentation/pages/home_page.dart';
import 'package:quran_khatma/features/quran/data/datasources/progress_local_datasource.dart';
import 'package:quran_khatma/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:quran_khatma/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:quran_khatma/features/quran/domain/usecases/get_progress.dart';
import 'package:quran_khatma/features/quran/domain/usecases/get_surah_ayahs.dart';
import 'package:quran_khatma/features/quran/domain/usecases/get_surahs.dart';
import 'package:quran_khatma/features/quran/domain/usecases/save_progress.dart';
import 'package:quran_khatma/features/quran/presentation/providers/quran_provider.dart';
import 'package:quran_khatma/features/quran/presentation/screens/quran_screen.dart';
import 'package:quran_khatma/features/quran/presentation/widgets/complete_wird_button.dart';
import 'package:quran_khatma/features/reward/data/datasources/hadith_local_datasource.dart';
import 'package:quran_khatma/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:quran_khatma/features/reward/presentation/pages/prophetic_reward_dialog.dart';
import 'package:quran_khatma/features/reward/presentation/providers/reward_provider.dart';
import 'package:quran_khatma/features/streak/data/datasources/streak_local_datasource.dart';
import 'package:quran_khatma/features/streak/data/repositories/streak_repository_impl.dart';
import 'package:quran_khatma/features/streak/domain/entities/streak.dart';
import 'package:quran_khatma/features/streak/domain/usecases/get_streak.dart';
import 'package:quran_khatma/features/streak/domain/usecases/record_reading_day.dart';
import 'package:quran_khatma/features/streak/presentation/models/achievement.dart';
import 'package:quran_khatma/features/streak/presentation/pages/journey_screen.dart';
import 'package:quran_khatma/features/streak/presentation/providers/streak_provider.dart';
import 'package:quran_khatma/features/streak/presentation/widgets/achievement_grid.dart';
import 'package:quran_khatma/features/streak/presentation/widgets/juz_journey_path.dart';
import 'package:quran_khatma/features/streak/presentation/widgets/streak_badge.dart';

const _sizes = <Size>[
  Size(360, 640),
  Size(390, 844),
  Size(700, 390),
  Size(768, 1024),
  Size(1024, 768),
  Size(1280, 800),
  Size(1920, 1080),
];

void _setView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

List<String> _trapOverflows(WidgetTester tester) {
  final overflows = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = '${details.exceptionAsString()}\n${details.summary}';
    if (text.contains('overflowed') || text.contains('OVERFLOWING')) {
      overflows.add(text);
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
  return overflows;
}

Widget _withScreenUtil({required Size size, required Widget home}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    enableScaleWH: () => size.width < 700,
    builder: (context, _) {
      return MaterialApp(
        locale: const Locale('ar'),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: home,
        ),
      );
    },
  );
}

Widget _withProviders({required Widget child}) {
  final quranRepository = QuranRepositoryImpl(
    quranLocal: QuranLocalDataSource(),
    progressLocal: ProgressLocalDataSource(),
  );
  final streakRepository = StreakRepositoryImpl(StreakLocalDataSource());
  final rewardRepository = RewardRepositoryImpl(HadithLocalDataSource());
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => QuranProvider(
          repository: quranRepository,
          getSurahs: GetSurahs(quranRepository),
          getSurahAyahs: GetSurahAyahs(quranRepository),
          getProgress: GetProgress(quranRepository),
          saveProgress: SaveProgress(quranRepository),
        )..load(),
      ),
      ChangeNotifierProvider(
        create: (_) => StreakProvider(
          getStreak: GetStreak(streakRepository),
          recordReadingDay: RecordReadingDay(streakRepository),
        )..load(),
      ),
      ChangeNotifierProvider(
        create: (_) => RewardProvider(rewardRepository)..load(),
      ),
    ],
    child: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('quran_khatma_hive');
    Hive.init(dir.path);
    await Future.wait([
      Hive.openBox<dynamic>(HiveBoxes.progress),
      Hive.openBox<dynamic>(HiveBoxes.settings),
      Hive.openBox<dynamic>(HiveBoxes.streak),
      Hive.openBox<dynamic>(HiveBoxes.rewards),
    ]);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('صور المصحف المحلية مكتملة (604 صفحة)', () {
    final dir = Directory('assets/mushaf/pages');
    expect(dir.existsSync(), isTrue);
    final pages = dir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.png'))
        .length;
    expect(pages, MushafAssets.totalPages);
    expect(File('assets/mushaf/pages/001.png').existsSync(), isTrue);
    expect(File('assets/mushaf/pages/604.png').existsSync(), isTrue);
  });

  testWidgets('عرض المحتوى لا يتجاوز الحدود على الحاسوب', (tester) async {
    _setView(tester, const Size(1920, 1080));
    late double maxWidth;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            maxWidth = Responsive.maxContentWidth(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(maxWidth, 840);
    expect(Responsive.indexPaneWidth(1920), inInclusiveRange(220, 300));
    expect(Responsive.indexPaneWidth(600), inInclusiveRange(220, 300));
  });

  for (final size in _sizes) {
    testWidgets('لا Overflow على ${size.width.toInt()}×${size.height.toInt()}',
        (tester) async {
      final overflows = _trapOverflows(tester);
      _setView(tester, size);

      await tester.pumpWidget(
        _withScreenUtil(
          size: size,
          home: Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width >= 1024
                      ? 840
                      : size.width >= 600
                          ? 720
                          : size.width,
                ),
                child: ListView(
                  children: [
                    const StreakBadge(
                      streak: Streak(current: 3, longest: 7),
                    ),
                    const SizedBox(height: 16),
                    CompleteWirdButton(onPressed: () {}),
                    const SizedBox(height: 16),
                    const JuzJourneyPath(completedJuz: 4, currentJuz: 5),
                    const SizedBox(height: 16),
                    AchievementGrid(
                      achievements: Achievement.fromProgress(
                        streakDays: 3,
                        longestStreak: 7,
                        completedJuz: 4,
                        started: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(overflows, isEmpty, reason: overflows.join('\n---\n'));
    });
  }

  for (final size in const [Size(390, 844), Size(768, 1024), Size(1280, 800)]) {
    testWidgets(
        'الشاشات الرئيسية بدون Overflow ${size.width.toInt()}×${size.height.toInt()}',
        (tester) async {
      final overflows = _trapOverflows(tester);
      _setView(tester, size);

      await tester.pumpWidget(
        _withProviders(
          child: _withScreenUtil(size: size, home: const HomePage()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(overflows, isEmpty, reason: overflows.join('\n---\n'));

      await tester.pumpWidget(
        _withProviders(
          child: _withScreenUtil(size: size, home: const JourneyScreen()),
        ),
      );
      await tester.pump();
      expect(find.byType(JourneyScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(overflows, isEmpty, reason: overflows.join('\n---\n'));

      await tester.pumpWidget(
        _withProviders(
          child: _withScreenUtil(size: size, home: const QuranScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.byType(QuranScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(overflows, isEmpty, reason: overflows.join('\n---\n'));
    });
  }

  testWidgets('حوار الكنز النبوي لا يفيض على الشاشات الضيقة والعريضة',
      (tester) async {
    for (final size in const [Size(360, 640), Size(390, 700), Size(1280, 800)]) {
      final overflows = _trapOverflows(tester);
      _setView(tester, size);
      await tester.pumpWidget(
        _withScreenUtil(size: size, home: const PropheticRewardDialog()),
      );
      await tester.pump();
      expect(find.byType(PropheticRewardDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(overflows, isEmpty, reason: overflows.join('\n---\n'));
    }
  });
}
