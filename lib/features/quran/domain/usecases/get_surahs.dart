import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetSurahs {
  const GetSurahs(this._repository);

  final QuranRepository _repository;

  List<Surah> call({String query = ''}) {
    final surahs = _repository.getSurahs();
    final normalized = query.trim();
    if (normalized.isEmpty) return surahs;

    return surahs.where((surah) {
      return surah.nameAr.contains(normalized) ||
          surah.nameEn.toLowerCase().contains(normalized.toLowerCase()) ||
          surah.number.toString() == normalized;
    }).toList();
  }
}
