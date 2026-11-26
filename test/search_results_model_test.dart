import 'package:flutter_test/flutter_test.dart';
import 'package:verbum/features/search_screen/data/models/search_results_model.dart';

void main() {
  test('converte passagem bíblica e elimina hinos duplicados', () {
    final results = SearchResultsModel.fromResponses(
      isBibleReferenceQuery: true,
      bibleUnavailable: false,
      harpaUnavailable: false,
      bibleResponse: {
        'reference': 'John 3:16',
        'translation_name': 'King James Version',
        'verses': [
          {'verse': 16, 'text': 'For God so loved the world.'},
        ],
      },
      harpaResponses: [
        {
          'hymns': [
            {'title': 'Jesus Comprou-me', 'number': 13},
          ],
        },
        {
          'hymns': [
            {'title': 'Jesus Comprou-me', 'number': 13},
            {'title': 'Glória a Jesus', 'number': 23},
          ],
        },
      ],
    ).toEntity();

    expect(results.passage?.reference, 'John 3:16');
    expect(results.passage?.verses.single.number, 16);
    expect(results.hymns, hasLength(2));
    expect(results.hymns.map((hymn) => hymn.number), [13, 23]);
  });

  test('mantém a consulta bíblica opcional para texto livre', () {
    final results = SearchResultsModel.fromResponses(
      isBibleReferenceQuery: false,
      bibleUnavailable: false,
      harpaUnavailable: false,
      harpaResponses: const [],
    ).toEntity();

    expect(results.isBibleReferenceQuery, isFalse);
    expect(results.passage, isNull);
    expect(results.hymns, isEmpty);
  });
}
