import '../entities/reading_progress.dart';
import '../repositories/quran_repository.dart';

class SaveProgress {
  const SaveProgress(this._repository);

  final QuranRepository _repository;

  Future<void> call(ReadingProgress progress) =>
      _repository.saveProgress(progress);
}
