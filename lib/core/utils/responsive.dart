import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// أدوات تجاوب الشاشات عبر الهاتف واللوحي والشاشات العريضة دون Overflow.
class Responsive {
  Responsive._();

  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isPhone(BuildContext context) => sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) {
    final width = sizeOf(context).width;
    return width >= 600 && width < 1024;
  }

  static bool isWide(BuildContext context) => sizeOf(context).width >= 1024;

  static bool usesSplitMushaf(BuildContext context) => sizeOf(context).width >= 600;

  static bool usesTwoPageSpread(BuildContext context) =>
      sizeOf(context).width >= 1024;

  static bool stackHomeActions(BuildContext context) =>
      sizeOf(context).width < 360;

  static EdgeInsets pagePadding(BuildContext context) {
    final width = sizeOf(context).width;
    if (width >= 1024) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 24);
    }
    if (width >= 600) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }

  static double maxContentWidth(BuildContext context) {
    final width = sizeOf(context).width;
    if (width >= 1024) return 840;
    if (width >= 600) return 720;
    return width;
  }

  static double indexPaneWidth(double maxWidth) {
    final ratio = maxWidth >= 1024 ? 0.26 : 0.34;
    return (maxWidth * ratio).clamp(220.0, 300.0);
  }

  static double capped(num design, double scaled) {
    return math.min(scaled, design * 1.35);
  }
}
