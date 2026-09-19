import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/quran/data/datasources/progress_local_datasource.dart';
import 'features/quran/data/datasources/quran_local_datasource.dart';
import 'features/quran/data/repositories/quran_repository_impl.dart';
import 'features/quran/domain/usecases/get_progress.dart';
import 'features/quran/domain/usecases/get_surah_ayahs.dart';
import 'features/quran/domain/usecases/get_surahs.dart';
import 'features/quran/domain/usecases/save_progress.dart';
import 'features/quran/presentation/providers/quran_provider.dart';
import 'features/reward/data/datasources/hadith_local_datasource.dart';
import 'features/reward/data/repositories/reward_repository_impl.dart';
import 'features/reward/presentation/providers/reward_provider.dart';
import 'features/streak/data/datasources/streak_local_datasource.dart';
import 'features/streak/data/repositories/streak_repository_impl.dart';
import 'features/streak/domain/usecases/get_streak.dart';
import 'features/streak/domain/usecases/record_reading_day.dart';
import 'features/streak/presentation/providers/streak_provider.dart';

class QuranKhatmaApp extends StatelessWidget {
  const QuranKhatmaApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        fontSizeResolver: (fontSize, instance) {
          final scale = instance.scaleText.clamp(0.9, 1.2);
          return fontSize * scale;
        },
        enableScaleWH: () {
          final views = WidgetsBinding.instance.platformDispatcher.views;
          if (views.isEmpty) return true;
          final view = views.first;
          final width = view.physicalSize.width / view.devicePixelRatio;
          return width < 700;
        },
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(
              textScaler: media.textScaler.clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 1.2,
              ),
            ),
            child: MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              locale: const Locale('ar'),
              supportedLocales: const [Locale('ar'), Locale('en')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, widget) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: widget ?? const SizedBox.shrink(),
                );
              },
              home: child,
            ),
          );
        },
        child: const HomePage(),
      ),
    );
  }
}
