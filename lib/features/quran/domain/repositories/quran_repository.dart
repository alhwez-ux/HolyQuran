import '../entities/ayah.dart';
import '../entities/mushaf_page_segment.dart';
import '../entities/reading_progress.dart';
import '../entities/surah.dart';

abstract class QuranRepository {
  List<Surah> getSurahs();

  List<Ayah> getAyahs(int surahNumber);

  Surah getSurah(int surahNumber);

  int pageNumberFor(int surahNumber, int ayahNumber);

  int firstPageOfSurah(int surahNumber);

  List<MushafPageSegment> segmentsOnPage(int pageNumber);

  List<Ayah> ayahsOnPage(int pageNumber);

  int juzFor(int surahNumber, int ayahNumber);

  Future<ReadingProgress> getProgress();

  Future<void> saveProgress(ReadingProgress progress);
}
