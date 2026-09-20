import 'package:flutter/material.dart';

/// ألوان مستوحاة من السكينة والطابع الإسلامي الهادئ، مع وضع نهاري وليلي.
class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF2B3F35);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color backgroundLight = Color(0xFFFAF9F5);
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color primary = primaryGreen;
  static const Color primaryLight = Color(0xFF3D5A4C);
  static const Color gold = goldAccent;
  static const Color goldSoft = Color(0xFFE8D48B);
  static const Color parchment = backgroundLight;
  static const Color parchmentDark = Color(0xFFE8E4DA);
  static const Color surface = cardBg;
  static const Color ink = textDark;
  static const Color muted = Color(0xFF6B6458);
  static const Color streak = Color(0xFFD97706);
  static const Color white = Color(0xFFFFFFF8);
  static const Color mushafPaper = Color(0xFFF8F3E8);

  static const Color readingOffWhite = Color(0xFFF3F0E8);
  static const Color readingLightGreen = Color(0xFFE6F0E3);
  static const Color readingLightMarine = Color(0xFFE2EEF4);
  static const Color readingNavy = Color(0xFF0B1C2C);
  static const Color readingNavyPanel = Color(0xFF122536);
  static const Color readingNavyText = Color(0xFFE6DCC8);
  static const Color backgroundNight = Color(0xFF0B1C2C);
  static const Color surfaceNight = Color(0xFF122536);
  static const Color parchmentNight = Color(0xFF161C14);
  static const Color mushafPaperNight = Color(0xFF0B0E0A);
  static const Color inkNight = Color(0xFFE7DCC8);
  static const Color mutedNight = Color(0xFFB3A894);
  static const Color borderNight = Color(0xFF3A4436);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffold(BuildContext context) =>
      isDark(context) ? backgroundNight : backgroundLight;

  static Color card(BuildContext context) =>
      isDark(context) ? surfaceNight : surface;

  static Color panel(BuildContext context) =>
      isDark(context) ? parchmentNight : parchment;

  static Color mushaf(BuildContext context) =>
      isDark(context) ? mushafPaperNight : mushafPaper;

  static Color body(BuildContext context) =>
      isDark(context) ? inkNight : ink;

  static Color subtle(BuildContext context) =>
      isDark(context) ? mutedNight : muted;

  static Color border(BuildContext context) =>
      isDark(context) ? borderNight : parchmentDark;

  static Color heading(BuildContext context) =>
      isDark(context) ? goldSoft : primary;

  /// مرشّح ليلي يقلب صفحة المصحف بلون دافئ مريح للعين.
  static const ColorFilter nightPageFilter = ColorFilter.matrix(<double>[
    -0.92, 0, 0, 0, 255,
    0, -0.86, 0, 0, 236,
    0, 0, -0.68, 0, 188,
    0, 0, 0, 1, 0,
  ]);
}
