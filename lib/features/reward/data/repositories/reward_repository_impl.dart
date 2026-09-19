import '../../domain/entities/hadith.dart';
import '../../domain/repositories/reward_repository.dart';
import '../datasources/hadith_local_datasource.dart';

class RewardRepositoryImpl implements RewardRepository {
  RewardRepositoryImpl(this._local);

  final HadithLocalDataSource _local;

  @override
  Future<bool> get canOpenToday async => !_local.openedToday;

  @override
  Future<Hadith?> get lastOpenedHadith async => _local.lastOpenedHadith();

  @override
  Future<Hadith> openTodayTreasure() => _local.openTreasure();
}
