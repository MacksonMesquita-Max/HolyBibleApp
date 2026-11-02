import 'bible_verse_model.dart';

class BiblePassageModel {
  const BiblePassageModel({
    required this.reference,
    required this.verses,
    required this.translationId,
    required this.translationName,
  });

  factory BiblePassageModel.fromJson(Map<String, dynamic> json) {
    final verses = json['verses'] as List<dynamic>? ?? const [];

    return BiblePassageModel(
      reference: json['reference'] as String? ?? '',
      verses: verses
          .whereType<Map<String, dynamic>>()
          .map(BibleVerseModel.fromJson)
          .toList(growable: false),
      translationId: json['translation_id'] as String? ?? '',
      translationName: json['translation_name'] as String? ?? '',
    );
  }

  final String reference;
  final List<BibleVerseModel> verses;
  final String translationId;
  final String translationName;
}
