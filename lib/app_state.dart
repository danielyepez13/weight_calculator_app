import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isDarkTheme = false;
  String _selectedLanguage = 'English';

  bool get isDarkTheme => _isDarkTheme;
  String get selectedLanguage => _selectedLanguage;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}