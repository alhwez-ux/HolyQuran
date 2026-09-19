class Surah {
  const Surah({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.ayahCount,
    required this.isMakki,
  });

  final int number;
  final String nameAr;
  final String nameEn;
  final int ayahCount;
  final bool isMakki;
}
