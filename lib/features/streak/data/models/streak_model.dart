import '../../domain/entities/streak.dart';

class StreakModel extends Streak {
  const StreakModel({
    super.current,
    super.longest,
    super.lastReadDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'current': current,
      'longest': longest,
      'lastReadDate': lastReadDate?.toIso8601String(),
    };
  }

  factory StreakModel.fromMap(Map<dynamic, dynamic> map) {
    final rawDate = map['lastReadDate'] as String?;
    return StreakModel(
      current: (map['current'] as int?) ?? 0,
      longest: (map['longest'] as int?) ?? 0,
      lastReadDate: rawDate == null ? null : DateTime.tryParse(rawDate),
    );
  }
}
