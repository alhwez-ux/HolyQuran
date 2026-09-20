import 'package:flutter/foundation.dart';

import '../../../../core/constants/mushaf_assets.dart';
import '../../domain/ayah_locator.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/mushaf_page_segment.dart';
import '../../domain/entities/reading_progress.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/usecases/get_progress.dart';
import '../../domain/usecases/get_surah_ayahs.dart';
import '../../domain/usecases/get_surahs.dart';
import '../../domain/usecases/save_progress.dart';

class QuranProvider extends ChangeNotifier {
  QuranProvider({
    required QuranRepository repository,
    required GetSurahs getSurahs,
    required GetSurahAyahs getSurahAyahs,
    required GetProgress getProgress,
    required SaveProgress saveProgress,
  })  : _repository = repository,
        _getSurahs = getSurahs,
        _getSurahAyahs = getSurahAyahs,
        _getProgress = getProgress,
        _saveProgress = saveProgress;

  final QuranRepository _repository;
  final GetSurahs _getSurahs;
  final GetSurahAyahs _getSurahAyahs;
  final GetProgress _getProgress;
  final SaveProgress _saveProgress;

  ReadingProgress _progress = const ReadingProgress();
  String _query = '';
  bool _loaded = false;

  List<Surah> get surahs => _getSurahs(query: _query);
  ReadingProgress get progress => _progress;
  String get query => _query;
  bool get loaded => _loaded;
  int get currentPage =>
      _progress.pageNumber.clamp(1, MushafAssets.totalPages);

  Future<void> load() async {
    _progress = await _getProgress();
    _loaded = true;
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  List<Ayah> ayahsOf(int surahNumber) => _getSurahAyahs(surahNumber);

  int pageOf(int surahNumber, [int ayahNumber = 1]) {
    return _repository.pageNumberFor(surahNumber, ayahNumber);
  }

  int firstPageOf(int surahNumber) => _repository.firstPageOfSurah(surahNumber);

  List<MushafPageSegment> segmentsOnPage(int pageNumber) {
    return _repository.segmentsOnPage(pageNumber);
  }

  List<Ayah> ayahsOnPage(int pageNumber) => _repository.ayahsOnPage(pageNumber);

  Surah surahByNumber(int surahNumber) => _repository.getSurah(surahNumber);

  int get currentJuz {
    return _repository.juzFor(_progress.surahNumber, _progress.ayahNumber);
  }

  int get completedJuzCount {
    if (currentPage >= MushafAssets.totalPages) return 30;
    return (currentJuz - 1).clamp(0, 30);
  }

  int khatmaPoints({int streakDays = 0}) {
    return completedJuzCount * 100 + streakDays * 20 + currentPage;
  }

  Future<void> savePosition({
    required int surahNumber,
    required int ayahNumber,
    int? pageNumber,
  }) async {
    _progress = ReadingProgress(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber:
          pageNumber ?? _repository.pageNumberFor(surahNumber, ayahNumber),
    );
    await _saveProgress(_progress);
    notifyListeners();
  }

  Future<void> saveStopAyah(Ayah ayah, {int? pageNumber}) {
    return savePosition(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.number,
      pageNumber: pageNumber,
    );
  }

  Ayah? ayahAtPageFraction(int pageNumber, double fraction) {
    final ayahs = ayahsOnPage(pageNumber);
    if (ayahs.isEmpty) return null;
    final index = ayahIndexForFraction(
      ayahCount: ayahs.length,
      fraction: fraction,
      centered: MushafAssets.usesCenteredLayout(pageNumber),
    );
    return ayahs[index];
  }

  bool isStopAyah(Ayah ayah) {
    return _progress.surahNumber == ayah.surahNumber &&
        _progress.ayahNumber == ayah.number;
  }

  Future<void> savePage(int pageNumber) async {
    final bounded = pageNumber.clamp(1, MushafAssets.totalPages);
    final ayahs = _repository.ayahsOnPage(bounded);
    if (ayahs.isEmpty) {
      final first = _repository.segmentsOnPage(bounded).first;
      await savePosition(
        surahNumber: first.surahNumber,
        ayahNumber: first.startAyah,
        pageNumber: bounded,
      );
      return;
    }
    final keepStop = ayahs.any(isStopAyah);
    final chosen = keepStop
        ? ayahs.firstWhere(isStopAyah)
        : ayahs.first;
    await savePosition(
      surahNumber: chosen.surahNumber,
      ayahNumber: chosen.number,
      pageNumber: bounded,
    );
  }

  Surah? get lastSurah {
    final all = _getSurahs();
    if (all.isEmpty) return null;
    return all.firstWhere(
      (surah) => surah.number == _progress.surahNumber,
      orElse: () => all.first,
    );
  }
}
