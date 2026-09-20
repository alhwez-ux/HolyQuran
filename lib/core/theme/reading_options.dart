import 'package:flutter/material.dart';

enum ReadingBackdrop {
  offWhite,
  lightGreen,
  lightMarine,
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
        return 'أبيض هادئ';
      case ReadingBackdrop.lightGreen:
        return 'أخضر فاتح';
      case ReadingBackdrop.lightMarine:
        return 'بحري فاتح';
      case ReadingBackdrop.navyNight:
        return 'ليلي كحلي';
    }
  }

  Color get canvas {
    switch (this) {
      case ReadingBackdrop.offWhite:
        return const Color(0xFFF3F0E8);
      case ReadingBackdrop.lightGreen:
        return const Color(0xFFE6F0E3);
      case ReadingBackdrop.lightMarine:
        return const Color(0xFFE2EEF4);
      case ReadingBackdrop.navyNight:
        return const Color(0xFF0B1C2C);
    }
  }

  Color get panel {
    switch (this) {
      case ReadingBackdrop.offWhite:
        return const Color(0xFFECE7DC);
      case ReadingBackdrop.lightGreen:
        return const Color(0xFFD8E6D4);
      case ReadingBackdrop.lightMarine:
        return const Color(0xFFD3E3EC);
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
