class SearchResults {
  const SearchResults({
    required this.isBibleReferenceQuery,
    required this.bibleUnavailable,
    required this.harpaUnavailable,
    this.passage,
    this.hymns = const [],
  });

  final bool isBibleReferenceQuery;
  final bool bibleUnavailable;
  final bool harpaUnavailable;
  final ScripturePassageMatch? passage;
  final List<HymnSearchMatch> hymns;
}

class ScripturePassageMatch {
  const ScripturePassageMatch({
    required this.reference,
    required this.translationName,
    required this.verses,
  });

  final String reference;
  final String translationName;
  final List<ScriptureVerseMatch> verses;
}

class ScriptureVerseMatch {
  const ScriptureVerseMatch({required this.number, required this.text});

  final int number;
  final String text;
}

class HymnSearchMatch {
  const HymnSearchMatch({required this.title, required this.number});

  final String title;
  final int number;
}
