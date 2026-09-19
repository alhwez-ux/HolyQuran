import '../entities/streak.dart';

abstract class StreakRepository {
  Future<Streak> getStreak();

  Future<Streak> recordReadingDay();
}
