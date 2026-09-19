import '../entities/streak.dart';
import '../repositories/streak_repository.dart';

class GetStreak {
  const GetStreak(this._repository);

  final StreakRepository _repository;

  Future<Streak> call() => _repository.getStreak();
}
