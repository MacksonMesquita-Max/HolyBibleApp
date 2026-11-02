import 'bible_verse.dart';

/// Uma passagem bíblica composta por um ou mais versículos e os dados da tradução.
class BiblePassage {
  const BiblePassage({
    required this.reference,
    required this.verses,
    required this.translationId,
    required this.translationName,
  });

  final String reference;
  final List<BibleVerse> verses;
  final String translationId;
  final String translationName;
}
