import 'package:flutter_test/flutter_test.dart';

import 'package:verbum/app/app.dart';

void main() {
  testWidgets('A tela inicial e renderizada', (WidgetTester tester) async {
    await tester.pumpWidget(const VerbumApp());

    expect(find.text('Verbum - Bíblia Sagrada'), findsWidgets);
  });
}
