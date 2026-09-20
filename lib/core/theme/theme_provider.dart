import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../database/hive_boxes.dart';
import 'reading_options.dart';

export 'reading_options.dart';

/// إعدادات القراءة: الخلفية، اتجاه التقليب، والوضع الليلي.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _load();
  }

  static const _themeKey = 'themeMode';
  static const _backdropKey = 'readingBackdrop';
  static const _turnKey = 'pageTurnStyle';

  ReadingBackdrop _backdrop = ReadingBackdrop.offWhite;
  PageTurnStyle _pageTurn = PageTurnStyle.horizontal;

  ReadingBackdrop get backdrop => _backdrop;
  PageTurnStyle get pageTurn => _pageTurn;

  bool get isDark => _backdrop.isNight;

  ThemeMode get mode => isDark ? ThemeMode.dark : ThemeMode.light;

  void _load() {
    final box = Hive.box<dynamic>(HiveBoxes.settings);
    final storedBackdrop = box.get(_backdropKey)?.toString();
    final storedTurn = box.get(_turnKey)?.toString();
    final storedTheme = box.get(_themeKey)?.toString();

    _backdrop = ReadingBackdrop.values.firstWhere(
      (item) => item.name == storedBackdrop,
      orElse: () => storedTheme == 'dark'
          ? ReadingBackdrop.navyNight
          : ReadingBackdrop.offWhite,
    );
    _pageTurn = PageTurnStyle.values.firstWhere(
      (item) => item.name == storedTurn,
      orElse: () => PageTurnStyle.horizontal,
    );
  }

  Future<void> setBackdrop(ReadingBackdrop value) async {
    if (_backdrop == value) return;
    _backdrop = value;
    final box = Hive.box<dynamic>(HiveBoxes.settings);
    await box.put(_backdropKey, value.name);
    await box.put(_themeKey, isDark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setPageTurn(PageTurnStyle value) async {
    if (_pageTurn == value) return;
    _pageTurn = value;
    await Hive.box<dynamic>(HiveBoxes.settings).put(_turnKey, value.name);
    notifyListeners();
  }

  Future<void> toggle() {
    return setBackdrop(
      isDark ? ReadingBackdrop.offWhite : ReadingBackdrop.navyNight,
    );
  }
}
