import '../../domain/entities/hymn.dart';

class HymnModel {
  const HymnModel({
    required this.title,
    required this.number,
    required this.author,
    required this.verses,
  });

  factory HymnModel.fromResponse(Map<String, dynamic> response) {
    final hymn = response['hymn'];
    if (hymn is! Map<String, dynamic>) {
      throw const FormatException('Resposta inválida ao carregar o hino.');
    }

    final title = hymn['title'];
    final number = hymn['number'];
    if (title is! String || title.trim().isEmpty || number is! num) {
      throw const FormatException('O hino retornado está incompleto.');
    }

    final rawVerses = hymn['verses'];
    final verses = rawVerses is List
        ? rawVerses
              .whereType<Map<String, dynamic>>()
              .map(HymnVerseModel.fromJson)
              .toList(growable: false)
        : const <HymnVerseModel>[];

    return HymnModel(
      title: title.trim(),
      number: number.toInt(),
      author: hymn['author'] as String? ?? '',
      verses: verses,
    );
  }

  final String title;
  final int number;
  final String author;
  final List<HymnVerseModel> verses;

  Hymn toEntity() {
    return Hymn(
      title: title,
      number: number,
      author: author,
      verses: verses.map((verse) => verse.toEntity()).toList(growable: false),
    );
  }
}

class HymnVerseModel {
  const HymnVerseModel({
    required this.sequence,
    required this.lyrics,
    required this.isChorus,
  });

  factory HymnVerseModel.fromJson(Map<String, dynamic> json) {
    return HymnVerseModel(
      sequence: (json['sequence'] as num?)?.toInt() ?? 0,
      lyrics: json['lyrics'] as String? ?? '',
      isChorus: json['chorus'] as bool? ?? false,
    );
  }

  final int sequence;
  final String lyrics;
  final bool isChorus;

  HymnVerse toEntity() {
    return HymnVerse(sequence: sequence, lyrics: lyrics, isChorus: isChorus);
  }
}
