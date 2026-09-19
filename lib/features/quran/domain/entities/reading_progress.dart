class ReadingProgress {
  const ReadingProgress({
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.pageNumber = 1,
  });

  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;

  bool get hasStarted => surahNumber > 1 || ayahNumber > 1 || pageNumber > 1;
}
