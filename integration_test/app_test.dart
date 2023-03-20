import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intellistudy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Smoke screen test', () {
    final sideMenu = find.byKey(const ValueKey('SideMenu'));

    testWidgets('App loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byWidget(SideM), findsOneWidget);
    });
  });
}
