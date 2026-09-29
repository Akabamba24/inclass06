import 'package:flutter_test/flutter_test.dart';
import 'package:smiley_painter/main.dart';

void main() {
  testWidgets('smiley lab renders expression and drawing controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmileyApp());
    await tester.pumpAndSettle();

    expect(find.text('Smiley Painter Lab'), findsOneWidget);
    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Sleepy'), findsOneWidget);
    expect(find.text('Surprised'), findsOneWidget);
    expect(find.textContaining('MOOD'), findsOneWidget);
    expect(find.text('ACCESSORIES'), findsOneWidget);
  });
}
