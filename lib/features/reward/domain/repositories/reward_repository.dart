import '../entities/hadith.dart';

abstract class RewardRepository {
  Future<bool> get canOpenToday;

  Future<Hadith?> get lastOpenedHadith;

  Future<Hadith> openTodayTreasure();
}
