/// تحديد الآية داخل صفحة المصحف من موضع اللمس الرأسي.
int ayahIndexForFraction({
  required int ayahCount,
  required double fraction,
  bool centered = false,
}) {
  if (ayahCount <= 0) return 0;
  final inset = centered ? 0.22 : 0.06;
  final span = 1 - (2 * inset);
  final inner = span <= 0
      ? fraction
      : ((fraction - inset) / span);
  final bounded = inner.clamp(0.0, 0.999999);
  return (bounded * ayahCount).floor().clamp(0, ayahCount - 1);
}
