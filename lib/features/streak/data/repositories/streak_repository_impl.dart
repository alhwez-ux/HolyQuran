import '../../domain/entities/streak.dart';
import '../../domain/repositories/streak_repository.dart';
import '../datasources/streak_local_datasource.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl(this._local);

  final StreakLocalDataSource _local;

  @override
  Future<Streak> getStreak() async => _local.getStreak();

  @override
  Future<Streak> recordReadingDay() => _local.recordReadingDay();
}
