import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbum/features/harpa_screen/application/ports/hymn_repository.dart';
import 'package:verbum/features/harpa_screen/application/use_cases/get_hymn_by_number_use_case.dart';
import 'package:verbum/features/harpa_screen/domain/entities/hymn.dart';
import 'package:verbum/features/harpa_screen/presentation/pages/harpa_page.dart';

void main() {
  testWidgets('carrega e apresenta o hino selecionado', (tester) async {
    final repository = _FakeHymnRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HarpaPage(
            getHymnByNumberUseCase: GetHymnByNumberUseCase(repository),
            initialHymnNumber: 13,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.requestedNumber, 13);
    expect(find.text('HINO 13'), findsOneWidget);
    expect(find.text('Jesus Comprou-me'), findsOneWidget);
    expect(find.text('Letra do hino selecionado.'), findsOneWidget);
  });
}

class _FakeHymnRepository implements HymnRepository {
  int? requestedNumber;

  @override
  Future<Hymn> getByNumber(int number) async {
    requestedNumber = number;
    return const Hymn(
      title: 'Jesus Comprou-me',
      number: 13,
      author: 'CPAD',
      verses: [
        HymnVerse(
          sequence: 1,
          lyrics: 'Letra do hino selecionado.',
          isChorus: false,
        ),
      ],
    );
  }
}
