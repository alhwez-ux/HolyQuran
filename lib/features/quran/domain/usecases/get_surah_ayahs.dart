import '../entities/ayah.dart';
import '../repositories/quran_repository.dart';

class GetSurahAyahs {
  const GetSurahAyahs(this._repository);

  final QuranRepository _repository;

  List<Ayah> call(int surahNumber) => _repository.getAyahs(surahNumber);
}
