import '../entities/reading_progress.dart';
import '../repositories/quran_repository.dart';

class GetProgress {
  const GetProgress(this._repository);

  final QuranRepository _repository;

  Future<ReadingProgress> call() => _repository.getProgress();
}
