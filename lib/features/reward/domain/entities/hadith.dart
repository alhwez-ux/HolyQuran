class Hadith {
  const Hadith({
    required this.id,
    required this.text,
    required this.narrator,
    required this.source,
    this.title = '',
  });

  final int id;
  final String title;
  final String text;
  final String narrator;
  final String source;
}
