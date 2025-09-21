import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider with ChangeNotifier {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeProvider() {
    _loadFromPrefs();
  }

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void _loadFromPrefs() {
    _isDarkMode = _box.read(_key) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.write(_key, _isDarkMode);
    notifyListeners();
  }

  ThemeData getTheme() {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: _isDarkMode ? const Color(0xFF121212) : Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: _isDarkMode ? Colors.white : Colors.black,
          backgroundColor: Colors.teal,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _isDarkMode ? const Color(0xFF1F1F1F) : Colors.teal,
      ),
      cardColor: _isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
      primaryColorDark: _isDarkMode ? const Color(0xFF121212) : Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
