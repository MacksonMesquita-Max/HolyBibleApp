/// Versículo exibido no card da home.
class DailyVerse {
  const DailyVerse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.translationId,
    required this.translationName,
  });

  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final String translationId;
  final String translationName;

  String get reference => '$bookName $chapter:$verse';
}
