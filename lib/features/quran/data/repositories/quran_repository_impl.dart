import '../../domain/entities/ayah.dart';
import '../../domain/entities/mushaf_page_segment.dart';
import '../../domain/entities/reading_progress.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/progress_local_datasource.dart';
import '../datasources/quran_local_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl({
    required QuranLocalDataSource quranLocal,
    required ProgressLocalDataSource progressLocal,
  })  : _quranLocal = quranLocal,
        _progressLocal = progressLocal;

  final QuranLocalDataSource _quranLocal;
  final ProgressLocalDataSource _progressLocal;

  @override
  List<Surah> getSurahs() => _quranLocal.getSurahs();

  @override
  Surah getSurah(int surahNumber) => _quranLocal.getSurah(surahNumber);

  @override
  List<Ayah> getAyahs(int surahNumber) => _quranLocal.getAyahs(surahNumber);

  @override
  int pageNumberFor(int surahNumber, int ayahNumber) {
    return _quranLocal.pageNumberFor(surahNumber, ayahNumber);
  }

  @override
  int firstPageOfSurah(int surahNumber) {
    return _quranLocal.firstPageOfSurah(surahNumber);
  }

  @override
  List<MushafPageSegment> segmentsOnPage(int pageNumber) {
    return _quranLocal.segmentsOnPage(pageNumber);
  }

  @override
  List<Ayah> ayahsOnPage(int pageNumber) => _quranLocal.ayahsOnPage(pageNumber);

  @override
  int juzFor(int surahNumber, int ayahNumber) {
    return _quranLocal.juzFor(surahNumber, ayahNumber);
  }

  @override
  Future<ReadingProgress> getProgress() async => _progressLocal.getProgress();

  @override
  Future<void> saveProgress(ReadingProgress progress) {
    return _progressLocal.saveProgress(progress);
  }
}
