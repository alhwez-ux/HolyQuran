/// تحويل الأرقام الغربية إلى أرقام عربية-هندية للعرض في المصحف.
String toArabicDigits(int number) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return number.toString().split('').map((char) {
    final index = western.indexOf(char);
    return index == -1 ? char : eastern[index];
  }).join();
}
