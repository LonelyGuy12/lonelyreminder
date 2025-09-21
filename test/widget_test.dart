import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lonelyreminder/main.dart';

void main() {
  testWidgets('App displays initial message when no events', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the initial message is displayed
    expect(find.text('No events found.'), findsOneWidget);
    expect(find.text('Tap the + button to add an event.'), findsOneWidget);
    expect(find.byIcon(Icons.event_note), findsOneWidget);
  });

  testWidgets('App has bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify bottom navigation bar exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('App has floating action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify floating action buttons exist
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
  });
}
