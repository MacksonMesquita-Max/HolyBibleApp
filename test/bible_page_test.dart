import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbum/features/bible_screen/application/dto/passage_request.dart';
import 'package:verbum/features/bible_screen/application/ports/bible_repository.dart';
import 'package:verbum/features/bible_screen/application/use_cases/get_passage_use_case.dart';
import 'package:verbum/features/bible_screen/domain/entities/bible_passage.dart';
import 'package:verbum/features/bible_screen/domain/entities/bible_verse.dart';
import 'package:verbum/features/bible_screen/presentation/pages/bible_page.dart';

void main() {
  testWidgets('consulta automaticamente a referência recebida', (tester) async {
    final repository = _FakeBibleRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BiblePage(
            getPassageUseCase: GetPassageUseCase(repository),
            initialReference: 'John 3',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.reference, 'John 3');
    expect(repository.translation, PassageRequest.defaultTranslation);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains(
              'Passagem carregada pelo destino.',
            ),
      ),
      findsOneWidget,
    );
  });
}

class _FakeBibleRepository implements BibleRepository {
  String? reference;
  String? translation;

  @override
  Future<BiblePassage> getPassage({
    required String reference,
    required String translation,
  }) async {
    this.reference = reference;
    this.translation = translation;
    return const BiblePassage(
      reference: 'John 3',
      translationId: 'kjv',
      translationName: 'King James Version',
      verses: [
        BibleVerse(
          bookId: 'John',
          bookName: 'John',
          chapter: 3,
          verse: 1,
          text: 'Passagem carregada pelo destino.',
        ),
      ],
    );
  }
}
