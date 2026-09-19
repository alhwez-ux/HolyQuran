/// مسارات صور صفحات مصحف مجمع الملك فهد المخزّنة محلياً.
class MushafAssets {
  MushafAssets._();

  static const int totalPages = 604;
  static const String directory = 'assets/mushaf/pages';

  static String pagePath(int pageNumber) {
    final padded = pageNumber.toString().padLeft(3, '0');
    return '$directory/$padded.png';
  }
}
