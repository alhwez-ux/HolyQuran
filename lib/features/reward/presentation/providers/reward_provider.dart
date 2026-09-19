import 'package:flutter/foundation.dart';

import '../../domain/entities/hadith.dart';
import '../../domain/repositories/reward_repository.dart';

class RewardProvider extends ChangeNotifier {
  RewardProvider(this._repository);

  final RewardRepository _repository;

  bool _canOpen = true;
  Hadith? _hadith;
  bool _opening = false;

  bool get canOpen => _canOpen;
  Hadith? get hadith => _hadith;
  bool get opening => _opening;

  Future<void> load() async {
    _canOpen = await _repository.canOpenToday;
    _hadith = await _repository.lastOpenedHadith;
    notifyListeners();
  }

  Future<Hadith> openTreasure() async {
    _opening = true;
    notifyListeners();
    final result = await _repository.openTodayTreasure();
    _hadith = result;
    _canOpen = false;
    _opening = false;
    notifyListeners();
    return result;
  }
}
