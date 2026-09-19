import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/database/hive_boxes.dart';
import '../../domain/entities/reading_progress.dart';

class ProgressLocalDataSource {
  Box<dynamic> get _box => Hive.box<dynamic>(HiveBoxes.progress);

  ReadingProgress getProgress() {
    final surah = _box.get('surahNumber', defaultValue: 1) as int;
    final ayah = _box.get('ayahNumber', defaultValue: 1) as int;
    final storedPage = _box.get('lastPage') ?? _box.get('pageNumber', defaultValue: 1);
    final page = (storedPage as int).clamp(1, MushafAssets.totalPages);
    return ReadingProgress(
      surahNumber: surah,
      ayahNumber: ayah,
      pageNumber: page,
    );
  }

  int get storedCompletedJuz {
    final value = _box.get('completedJuz');
    if (value is int) return value.clamp(0, 30);
    return completedJuzFor(getProgress());
  }

  int get storedPoints {
    final value = _box.get('khatmaPoints');
    return value is int ? value : 0;
  }

  Future<void> saveProgress(ReadingProgress progress) async {
    final completed = completedJuzFor(progress);
    final points = completed * 100 + progress.pageNumber;
    await _box.put('surahNumber', progress.surahNumber);
    await _box.put('ayahNumber', progress.ayahNumber);
    await _box.put('pageNumber', progress.pageNumber);
    await _box.put('lastPage', progress.pageNumber);
    await _box.put('completedJuz', completed);
    await _box.put('khatmaPoints', points);
  }

  static int completedJuzFor(ReadingProgress progress) {
    if (progress.pageNumber >= MushafAssets.totalPages) return 30;
    try {
      final juz = quran.getJuzNumber(progress.surahNumber, progress.ayahNumber);
      return (juz - 1).clamp(0, 30);
    } catch (_) {
      return 0;
    }
  }
}
