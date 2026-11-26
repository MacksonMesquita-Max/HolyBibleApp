import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbum/features/search_screen/application/ports/search_repository.dart';
import 'package:verbum/features/search_screen/application/use_cases/search_content_use_case.dart';
import 'package:verbum/features/search_screen/domain/entities/search_results.dart';
import 'package:verbum/features/search_screen/presentation/pages/search_page.dart';

void main() {
  testWidgets('mostra atalhos e encaminha a referência ao destino', (
    tester,
  ) async {
    final repository = _FakeSearchRepository(
      const SearchResults(
        isBibleReferenceQuery: true,
        bibleUnavailable: false,
        harpaUnavailable: false,
        passage: ScripturePassageMatch(
          reference: 'John 3:1-2',
          translationName: 'King James Version',
          verses: [
            ScriptureVerseMatch(number: 1, text: 'Primeiro versículo.'),
            ScriptureVerseMatch(number: 2, text: 'Segundo versículo.'),
          ],
        ),
        hymns: [HymnSearchMatch(title: 'Jesus Comprou-me', number: 13)],
      ),
    );
    String? openedReference;
    int? openedHymnNumber;

    await tester.pumpWidget(
      MaterialApp(
        home: SearchPage(
          searchContentUseCase: SearchContentUseCase(repository),
          onOpenBibleReference: (reference) => openedReference = reference,
          onOpenHymn: (number) => openedHymnNumber = number,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'John 3');
    await tester.tap(find.byTooltip('Pesquisar'));
    await tester.pumpAndSettle();

    expect(repository.lastQuery, 'John 3');
    expect(find.text('John 3:1-2'), findsOneWidget);
    expect(find.text('Primeiro versículo.'), findsNothing);
    expect(find.text('Jesus Comprou-me'), findsOneWidget);

    await tester.tap(find.text('John 3:1-2'));
    expect(openedReference, 'John 3');

    await tester.tap(find.text('Jesus Comprou-me'));
    expect(openedHymnNumber, 13);
  });
}

class _FakeSearchRepository implements SearchRepository {
  _FakeSearchRepository(this.results);

  final SearchResults results;
  String? lastQuery;

  @override
  Future<SearchResults> search(String query) async {
    lastQuery = query;
    return results;
  }
}
