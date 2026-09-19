/// نطاق آيات سورة واحدة تظهر في صفحة من المصحف.
class MushafPageSegment {
  const MushafPageSegment({
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  });

  final int surahNumber;
  final int startAyah;
  final int endAyah;
}
