// Teste de smoke basico do aplicativo.

import 'package:flutter_test/flutter_test.dart';

import 'package:holy_bible_app/main.dart';

void main() {
  testWidgets('A tela inicial e renderizada', (WidgetTester tester) async {
    await tester.pumpWidget(const HolyBibleApp());

    expect(find.text('Biblia Sagrada'), findsWidgets);
  });
}
