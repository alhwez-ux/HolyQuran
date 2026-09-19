import 'package:quran/quran.dart' as quran;

import '../../domain/entities/ayah.dart';
import '../../domain/entities/mushaf_page_segment.dart';
import '../../domain/entities/surah.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

/// مصدر نص المصحف وترقيم صفحات مجمع الملك فهد المخزّن محلياً.
class QuranLocalDataSource {
  List<Surah> getSurahs() {
    return List<Surah>.generate(quran.totalSurahCount, (index) {
      final number = index + 1;
      return getSurah(number);
    });
  }

  Surah getSurah(int surahNumber) {
    final revelation = quran.getPlaceOfRevelation(surahNumber);
    return SurahModel(
      number: surahNumber,
      nameAr: quran.getSurahNameArabic(surahNumber),
      nameEn: quran.getSurahNameEnglish(surahNumber),
      ayahCount: quran.getVerseCount(surahNumber),
      isMakki: revelation.toLowerCase().contains('makkah') ||
          revelation.contains('مك'),
    );
  }

  List<Ayah> getAyahs(int surahNumber) {
    final count = quran.getVerseCount(surahNumber);
    return List<Ayah>.generate(count, (index) {
      final number = index + 1;
      return AyahModel(
        surahNumber: surahNumber,
        number: number,
        text: quran.getVerse(surahNumber, number, verseEndSymbol: false),
      );
    });
  }

  int pageNumberFor(int surahNumber, int ayahNumber) {
    return quran.getPageNumber(surahNumber, ayahNumber);
  }

  int firstPageOfSurah(int surahNumber) {
    final pages = quran.getSurahPages(surahNumber);
    return pages.isEmpty ? 1 : pages.first;
  }

  List<MushafPageSegment> segmentsOnPage(int pageNumber) {
    final raw = quran.getPageData(pageNumber);
    return [
      for (final item in raw)
        MushafPageSegment(
          surahNumber: int.parse(item['surah'].toString()),
          startAyah: int.parse(item['start'].toString()),
          endAyah: int.parse(item['end'].toString()),
        ),
    ];
  }

  List<Ayah> ayahsOnPage(int pageNumber) {
    final ayahs = <Ayah>[];
    for (final segment in segmentsOnPage(pageNumber)) {
      for (var number = segment.startAyah; number <= segment.endAyah; number++) {
        ayahs.add(
          AyahModel(
            surahNumber: segment.surahNumber,
            number: number,
            text: quran.getVerse(
              segment.surahNumber,
              number,
              verseEndSymbol: false,
            ),
          ),
        );
      }
    }
    return ayahs;
  }

  int juzFor(int surahNumber, int ayahNumber) {
    try {
      final juz = quran.getJuzNumber(surahNumber, ayahNumber);
      return juz < 1 ? 1 : juz;
    } catch (_) {
      return 1;
    }
  }
}
