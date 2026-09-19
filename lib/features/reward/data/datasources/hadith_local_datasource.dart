import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_boxes.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../domain/entities/hadith.dart';
import 'hadith_catalog.dart';

class HadithLocalDataSource {
  Box<dynamic> get _box => Hive.box<dynamic>(HiveBoxes.rewards);

  List<Hadith> get catalog => List<Hadith>.from(offlineHadiths);

  bool get openedToday {
    final raw = _box.get('lastOpenedDate') as String?;
    return AppDateUtils.isToday(AppDateUtils.parseIsoDate(raw));
  }

  Hadith? lastOpenedHadith() {
    final id = _box.get('lastHadithId') as int?;
    if (id == null) return null;
    try {
      return catalog.firstWhere((hadith) => hadith.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Hadith> openTreasure() async {
    if (openedToday) {
      return lastOpenedHadith() ?? catalog.first;
    }

    final lastId = _box.get('lastHadithId') as int?;
    final pool = catalog.where((hadith) => hadith.id != lastId).toList();
    pool.shuffle();
    final chosen = pool.isEmpty ? catalog.first : pool.first;

    await _box.put('lastHadithId', chosen.id);
    await _box.put('lastOpenedDate', AppDateUtils.toIsoDate(DateTime.now()));
    final count = (_box.get('openedCount', defaultValue: 0) as int) + 1;
    await _box.put('openedCount', count);
    return chosen;
  }
}
