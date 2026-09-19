import '../../domain/entities/hadith.dart';

class HadithModel extends Hadith {
  const HadithModel({
    required super.id,
    required super.text,
    required super.narrator,
    required super.source,
    super.title,
  });

  factory HadithModel.fromMap(Map<String, dynamic> map) {
    return HadithModel(
      id: map['id'] as int,
      title: (map['title'] as String?) ?? '',
      text: map['text'] as String,
      narrator: (map['narrator'] as String?) ?? '',
      source: map['source'] as String,
    );
  }
}
