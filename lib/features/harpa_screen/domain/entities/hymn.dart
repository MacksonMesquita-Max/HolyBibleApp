class Hymn {
  const Hymn({
    required this.title,
    required this.number,
    required this.author,
    required this.verses,
  });

  final String title;
  final int number;
  final String author;
  final List<HymnVerse> verses;
}

class HymnVerse {
  const HymnVerse({
    required this.sequence,
    required this.lyrics,
    required this.isChorus,
  });

  final int sequence;
  final String lyrics;
  final bool isChorus;
}
