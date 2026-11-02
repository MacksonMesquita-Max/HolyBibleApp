/// Resposta de `GET /data/{translation}/random`.
///
/// Formato próprio da API, diferente do usado na busca por referência:
/// os dados vêm aninhados em `random_verse` e `translation`.
class DailyVerseModel {
  const DailyVerseModel({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.translationId,
    required this.translationName,
  });

  factory DailyVerseModel.fromJson(Map<String, dynamic> json) {
    final verse = json['random_verse'] as Map<String, dynamic>? ?? const {};
    final translation =
        json['translation'] as Map<String, dynamic>? ?? const {};

    return DailyVerseModel(
      bookId: verse['book_id'] as String? ?? '',
      bookName: verse['book'] as String? ?? '',
      chapter: (verse['chapter'] as num?)?.toInt() ?? 0,
      verse: (verse['verse'] as num?)?.toInt() ?? 0,
      text: (verse['text'] as String? ?? '').trim(),
      translationId: translation['identifier'] as String? ?? '',
      translationName: translation['name'] as String? ?? '',
    );
  }

  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final String translationId;
  final String translationName;
}
