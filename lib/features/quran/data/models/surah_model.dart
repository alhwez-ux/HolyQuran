import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.nameAr,
    required super.nameEn,
    required super.ayahCount,
    required super.isMakki,
  });
}
