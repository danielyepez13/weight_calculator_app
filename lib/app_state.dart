import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isDarkTheme = false;
  String _selectedLanguage = 'English';
  List<Map<String, String>> history = [];

  final Map<String, Map<String, String>> translations = {
    'English': {
      'title': 'Weight Calculator',
      'heightHint': 'Height (m)',
      'weightHint': 'Weight (kg)',
      'calculate': 'Calculate',
      'overweight': 'You\'re overweight',
      'normalWeight': 'You have normal weight',
      'underweight': 'You\'re underweight',
      'error': 'Please enter valid values',
      'history': 'History',
      'history_no_available': 'No history available',
      'height': 'Height',
      'weight': 'Weight',
      'confirm_delete': 'Confirm Deletion',
      'confirm_delete_message': 'Are you sure you want to delete the history?',
      'cancel': 'Cancel',
      'delete': 'Delete',
    },
    'Español': {
      'title': 'Calculadora de Peso',
      'heightHint': 'Altura (m)',
      'weightHint': 'Peso (kg)',
      'calculate': 'Calcular',
      'overweight': 'Tienes sobrepeso',
      'normalWeight': 'Tienes un peso normal',
      'underweight': 'Tienes bajo peso',
      'error': 'Por favor ingrese valores válidos',
      'history': 'Historial',
      'history_no_available': 'No hay historial disponible',
      'height': 'Altura',
      'weight': 'Peso',
      'confirm_delete': 'Confirmar Eliminación',
      'confirm_delete_message': '¿Estás seguro de que quieres eliminar el historial?',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
    },
  };

  bool get isDarkTheme => _isDarkTheme;
  String get selectedLanguage => _selectedLanguage;

  AppState() {
    _loadHistory();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void addHistoryEntry(String height, String weight, String bmi) {
    history.add({'height': height, 'weight': weight, 'bmi': bmi});
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = history.map((entry) => entry.toString()).toList();
    await prefs.setStringList('history', historyList);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history') ?? [];
    history = historyList.map((entry) {
      final Map<String, String> map = {};
      entry.substring(1, entry.length - 1).split(', ').forEach((element) {
        final keyValue = element.split(': ');
        map[keyValue[0]] = keyValue[1];
      });
      return map;
    }).toList();
    notifyListeners();
  }
}