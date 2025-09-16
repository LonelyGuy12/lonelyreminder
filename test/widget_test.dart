import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reminderapp/main.dart';

void main() {
  testWidgets('App displays initial message when no events', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp()); // No databaseService parameter

    // Verify that the initial message is displayed
    expect(find.text('No events found.\nTap the + button to scan an image for event details.'), findsOneWidget);
    expect(find.byType(ListView), findsNothing); // Ensure no ListView is present initially
  });
}
