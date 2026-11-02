class BibleVerseModel {
  const BibleVerseModel({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory BibleVerseModel.fromJson(Map<String, dynamic> json) {
    return BibleVerseModel(
      bookId: json['book_id'] as String? ?? '',
      bookName: json['book_name'] as String? ?? '',
      chapter: (json['chapter'] as num?)?.toInt() ?? 0,
      verse: (json['verse'] as num?)?.toInt() ?? 0,
      text: (json['text'] as String? ?? '').trim(),
    );
  }

  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
}
