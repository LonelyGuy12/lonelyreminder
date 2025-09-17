import 'package:flutter/material.dart';
import 'package:lonelyreminder/ocrtest.dart'; // Import the screen we just finished

void main() {
  // It's good practice to ensure Flutter is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lonely Reminder',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      // Let's add a simple dark theme to match the style you like.
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212), // A nice dark background
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal, // Button text color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the OcrTest widget as the first screen of the app.
      home: const OcrTest(),
    );
  }
}
