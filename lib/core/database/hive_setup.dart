import 'package:hive_flutter/hive_flutter.dart';

import 'hive_boxes.dart';

/// تهيئة قاعدة البيانات المحلية (Hive) عند إقلاع التطبيق.
class HiveSetup {
  HiveSetup._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(HiveBoxes.progress),
      Hive.openBox<dynamic>(HiveBoxes.settings),
      Hive.openBox<dynamic>(HiveBoxes.streak),
      Hive.openBox<dynamic>(HiveBoxes.rewards),
    ]);
  }
}
