import 'package:flutter/material.dart';

const Duration kReadingBackdropAnim = Duration(milliseconds: 320);

enum ReadingBackdrop {
  offWhite,
  lightGreen,
  lightMarine,
  warmCream,
  desertSand,
  pearlGray,
  navyNight,
}

enum PageTurnStyle {
  horizontal,
  vertical,
}

extension ReadingBackdropX on ReadingBackdrop {
  bool get isNight => this == ReadingBackdrop.navyNight;

  String get label {
    switch (this) {
      case ReadingBackdrop.offWhite:
        return 'أبيض غير ناصع';
      case ReadingBackdrop.lightGreen:
        return 'أخضر فاتح هادئ';
      case ReadingBackdrop.lightMarine:
        return 'بحري فاتح';
      case ReadingBackdrop.warmCream:
        return 'سكري دافئ';
      case ReadingBackdrop.desertSand:
        return 'بيج صحراوي';
      case ReadingBackdrop.pearlGray:
        return 'رمادي لؤلؤي';
      case ReadingBackdrop.navyNight:
        return 'ليلي كحلي';
    }
  }

  Color get canvas {
    switch (this) {
      case ReadingBackdrop.offWhite:
        return const Color(0xFFF5F2EB);
      case ReadingBackdrop.lightGreen:
        return const Color(0xFFE6F1EA);
      case ReadingBackdrop.lightMarine:
        return const Color(0xFFE1EEF4);
      case ReadingBackdrop.warmCream:
        return const Color(0xFFF4E8D0);
      case ReadingBackdrop.desertSand:
        return const Color(0xFFE7D4B8);
      case ReadingBackdrop.pearlGray:
        return const Color(0xFFE4E0D8);
      case ReadingBackdrop.navyNight:
        return const Color(0xFF0B1C2C);
    }
  }

  Color get panel {
    switch (this) {
      case ReadingBackdrop.offWhite:
        return const Color(0xFFEBE6DC);
      case ReadingBackdrop.lightGreen:
        return const Color(0xFFD4E6DB);
      case ReadingBackdrop.lightMarine:
        return const Color(0xFFD0E0EA);
      case ReadingBackdrop.warmCream:
        return const Color(0xFFE8D9BC);
      case ReadingBackdrop.desertSand:
        return const Color(0xFFD9C3A6);
      case ReadingBackdrop.pearlGray:
        return const Color(0xFFD5D0C7);
      case ReadingBackdrop.navyNight:
        return const Color(0xFF122536);
    }
  }

  Color get heading {
    switch (this) {
      case ReadingBackdrop.navyNight:
        return const Color(0xFFE8D48B);
      case ReadingBackdrop.offWhite:
      case ReadingBackdrop.lightGreen:
      case ReadingBackdrop.lightMarine:
      case ReadingBackdrop.warmCream:
      case ReadingBackdrop.desertSand:
      case ReadingBackdrop.pearlGray:
        return const Color(0xFF2B3F35);
    }
  }

  Color get body {
    return isNight ? const Color(0xFFE6DCC8) : const Color(0xFF2C2C2C);
  }

  Color get muted {
    return isNight ? const Color(0xFFB7C4CE) : const Color(0xFF6B6458);
  }

  Color get onAccent {
    return isNight ? const Color(0xFFE6DCC8) : const Color(0xFF2B3F35);
  }
}

extension PageTurnStyleX on PageTurnStyle {
  bool get isVertical => this == PageTurnStyle.vertical;
}
