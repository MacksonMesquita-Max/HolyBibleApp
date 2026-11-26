import '../../domain/entities/search_results.dart';

class SearchResultsModel {
  const SearchResultsModel({
    required this.isBibleReferenceQuery,
    required this.bibleUnavailable,
    required this.harpaUnavailable,
    required this.hymns,
    this.passage,
  });

  factory SearchResultsModel.fromResponses({
    required bool isBibleReferenceQuery,
    required bool bibleUnavailable,
    required bool harpaUnavailable,
    Map<String, dynamic>? bibleResponse,
    List<Map<String, dynamic>> harpaResponses = const [],
  }) {
    final passage = bibleResponse == null
        ? null
        : ScripturePassageModel.fromJson(bibleResponse);
    final hymnsByNumber = <int, HymnSearchModel>{};

    for (final response in harpaResponses) {
      final entries = response['hymns'];
      if (entries is! List) {
        continue;
      }

      for (final entry in entries.whereType<Map<String, dynamic>>()) {
        final hymn = HymnSearchModel.tryParse(entry);
        if (hymn != null) {
          hymnsByNumber.putIfAbsent(hymn.number, () => hymn);
        }
      }
    }

    return SearchResultsModel(
      isBibleReferenceQuery: isBibleReferenceQuery,
      bibleUnavailable: bibleUnavailable,
      harpaUnavailable: harpaUnavailable,
      passage: passage,
      hymns: hymnsByNumber.values.toList(growable: false),
    );
  }

  final bool isBibleReferenceQuery;
  final bool bibleUnavailable;
  final bool harpaUnavailable;
  final ScripturePassageModel? passage;
  final List<HymnSearchModel> hymns;

  SearchResults toEntity() {
    return SearchResults(
      isBibleReferenceQuery: isBibleReferenceQuery,
      bibleUnavailable: bibleUnavailable,
      harpaUnavailable: harpaUnavailable,
      passage: passage?.toEntity(),
      hymns: hymns.map((hymn) => hymn.toEntity()).toList(growable: false),
    );
  }
}

class ScripturePassageModel {
  const ScripturePassageModel({
    required this.reference,
    required this.translationName,
    required this.verses,
  });

  factory ScripturePassageModel.fromJson(Map<String, dynamic> json) {
    final rawVerses = json['verses'];

    return ScripturePassageModel(
      reference: json['reference'] as String? ?? '',
      translationName: json['translation_name'] as String? ?? '',
      verses: rawVerses is List
          ? rawVerses
                .whereType<Map<String, dynamic>>()
                .map(ScriptureVerseModel.fromJson)
                .toList(growable: false)
          : const [],
    );
  }

  final String reference;
  final String translationName;
  final List<ScriptureVerseModel> verses;

  ScripturePassageMatch toEntity() {
    return ScripturePassageMatch(
      reference: reference,
      translationName: translationName,
      verses: verses.map((verse) => verse.toEntity()).toList(growable: false),
    );
  }
}

class ScriptureVerseModel {
  const ScriptureVerseModel({required this.number, required this.text});

  factory ScriptureVerseModel.fromJson(Map<String, dynamic> json) {
    return ScriptureVerseModel(
      number: (json['verse'] as num?)?.toInt() ?? 0,
      text: (json['text'] as String? ?? '').trim(),
    );
  }

  final int number;
  final String text;

  ScriptureVerseMatch toEntity() {
    return ScriptureVerseMatch(number: number, text: text);
  }
}

class HymnSearchModel {
  const HymnSearchModel({required this.title, required this.number});

  static HymnSearchModel? tryParse(Map<String, dynamic> json) {
    final title = json['title'];
    final number = json['number'];
    if (title is! String || title.trim().isEmpty || number is! num) {
      return null;
    }

    return HymnSearchModel(title: title.trim(), number: number.toInt());
  }

  final String title;
  final int number;

  HymnSearchMatch toEntity() {
    return HymnSearchMatch(title: title, number: number);
  }
}
