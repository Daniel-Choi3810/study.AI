import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellistudy/view/components/flashcard_create_page/formatted_response.dart';
import 'package:intellistudy/main.dart';

void main() {
  testWidgets('update the UI when generating a response', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // Smoke screen test to make sure the UI is rendering
    expect(find.widgetWithText(AppBar, 'IntelliStudy'), findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    expect(
        find.widgetWithText(FloatingActionButton, "Clear All"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Create"), findsOneWidget);
    // expect(find.widgetWithText(SearchField, "Enter your question..."),
    // findsOneWidget);

    // Generate a response and re-render
    // await tester.tap(find.byType(SearchField));
    // await tester.enterText(find.byType(SearchField), 'Helllo World');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(seconds: 3));

    // The state have properly updated
    expect(
        find.widgetWithText(FormattedResponse, 'Hello World'), findsOneWidget);
  });
}
