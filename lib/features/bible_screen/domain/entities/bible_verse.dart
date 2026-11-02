/// Um versículo individual de uma passagem bíblica.
class BibleVerse {
  const BibleVerse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  String get label => '$bookName $chapter:$verse';
}
