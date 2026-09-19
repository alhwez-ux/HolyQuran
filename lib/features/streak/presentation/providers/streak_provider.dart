import 'package:flutter/foundation.dart';

import '../../../../core/utils/app_date_utils.dart';
import '../../domain/entities/streak.dart';
import '../../domain/usecases/get_streak.dart';
import '../../domain/usecases/record_reading_day.dart';

class StreakProvider extends ChangeNotifier {
  StreakProvider({
    required GetStreak getStreak,
    required RecordReadingDay recordReadingDay,
  })  : _getStreak = getStreak,
        _recordReadingDay = recordReadingDay;

  final GetStreak _getStreak;
  final RecordReadingDay _recordReadingDay;

  Streak _streak = const Streak();

  Streak get streak => _streak;
  bool get readToday => AppDateUtils.isToday(_streak.lastReadDate);

  Future<void> load() async {
    _streak = await _getStreak();
    notifyListeners();
  }

  Future<void> recordToday() async {
    _streak = await _recordReadingDay();
    notifyListeners();
  }
}
