import 'package:flutter_test/flutter_test.dart';
import 'package:soccer_stats_hub/main.dart';

void main() {
  testWidgets('Aplicação inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const SoccerInspectorApp());

    expect(find.byType(SoccerInspectorApp), findsOneWidget);
  });
}
