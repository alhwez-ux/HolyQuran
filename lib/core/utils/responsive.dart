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

  /// هامش بصري نظيف حول صفحة المصحف حسب عرض الجهاز.
  static double mushafFullscreenGutter(double width) {
    if (width >= 1024) return 24;
    if (width >= 600) return 18;
    return 14;
  }

  /// هوامش أمان لصور المصحف حتى لا تلامس الحواف أو شريط التحكم السفلي.
  static EdgeInsets mushafPageInsets(
    BuildContext context, {
    required bool fullscreen,
  }) {
    final safe = MediaQuery.paddingOf(context);
    final size = sizeOf(context);
    final width = size.width;
    final side = mushafFullscreenGutter(width);
    final top = width >= 1024 ? 18.0 : width >= 600 ? 14.0 : 12.0;
    final bottom = width >= 1024 ? 28.0 : width >= 600 ? 24.0 : 22.0;

    if (!fullscreen) {
      return EdgeInsets.fromLTRB(side, top, side, bottom);
    }

    final fabClearance = (size.height * 0.055).clamp(32.0, 52.0);
    return EdgeInsets.fromLTRB(
      safe.left + side,
      safe.top + top,
      safe.right + side,
      bottom + fabClearance,
    );
  }
}
