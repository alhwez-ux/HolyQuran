import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_boxes.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../domain/entities/streak.dart';
import '../models/streak_model.dart';

class StreakLocalDataSource {
  Box<dynamic> get _box => Hive.box<dynamic>(HiveBoxes.streak);

  Streak getStreak() {
    return StreakModel.fromMap({
      'current': _box.get('current', defaultValue: 0),
      'longest': _box.get('longest', defaultValue: 0),
      'lastReadDate': _box.get('lastReadDate'),
    });
  }

  Future<Streak> recordReadingDay() async {
    final current = getStreak();
    if (AppDateUtils.isToday(current.lastReadDate)) {
      return current;
    }

    final nextCurrent = AppDateUtils.isYesterday(current.lastReadDate)
        ? current.current + 1
        : 1;
    final nextLongest =
        nextCurrent > current.longest ? nextCurrent : current.longest;
    final updated = StreakModel(
      current: nextCurrent,
      longest: nextLongest,
      lastReadDate: AppDateUtils.dateOnly(DateTime.now()),
    );

    await _box.put('current', updated.current);
    await _box.put('longest', updated.longest);
    await _box.put('lastReadDate', AppDateUtils.toIsoDate(updated.lastReadDate!));
    return updated;
  }
}
