import '../entities/streak.dart';
import '../repositories/streak_repository.dart';

class RecordReadingDay {
  const RecordReadingDay(this._repository);

  final StreakRepository _repository;

  Future<Streak> call() => _repository.recordReadingDay();
}
