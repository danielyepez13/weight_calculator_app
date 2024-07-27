import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history.dart';
import '../app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmiResult = 0;
  String _textResult = '';
  String _errorMessage = '';
  bool _showError = false;
  final List<Map<String, String>> languages = [
    {'name': 'English', 'flag': '🇬🇧'},
    {'name': 'Español', 'flag': '🇪🇸'},
  ];

  void _handleLanguageChange(String? newValue) {
    if (newValue != null) {
      Provider.of<AppState>(context, listen: false).changeLanguage(newValue);
      _updateResultText();
    }
  }

  void _showErrorNotification(String message) {
    setState(() {
      _errorMessage = message;
      _showError = true;
    });
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _showError = false;
        });
      }
    });
  }

  void _updateResultText() {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentTranslations = appState.translations[appState.selectedLanguage]!;

    if (_bmiResult > 25) {
      _textResult = currentTranslations['overweight']!;
    } else if (_bmiResult >= 18.5 && _bmiResult <= 25) {
      _textResult = currentTranslations['normalWeight']!;
    } else {
      _textResult = currentTranslations['underweight']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentTranslations = appState.translations[appState.selectedLanguage]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentTranslations['title']!,
          style: TextStyle(
            fontSize: 32,
            color: appState.isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: appState.isDarkTheme ? Colors.black : Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: appState.isDarkTheme ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _heightController,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: appState.isDarkTheme ? Colors.white : Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: currentTranslations['heightHint'],
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: appState.isDarkTheme
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: appState.isDarkTheme ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _weightController,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: appState.isDarkTheme ? Colors.white : Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: currentTranslations['weightHint'],
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: appState.isDarkTheme
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _errorMessage = '';
                      try {
                        double h = double.parse(_heightController.text);
                        double w = double.parse(_weightController.text);
                        if (h <= 0 || w <= 0) {
                          _showErrorNotification(currentTranslations['error']!);
                          return;
                        }
                        _bmiResult = w / (h * h);
                        _updateResultText();
                        appState.addHistoryEntry(_heightController.text, _weightController.text, _bmiResult.toStringAsFixed(2));
                      } catch (e) {
                        _showErrorNotification(currentTranslations['error']!);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: appState.isDarkTheme ? Colors.grey[800] : Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      currentTranslations['calculate']!,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: appState.isDarkTheme ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  _bmiResult.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 90,
                    color: appState.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _textResult.isNotEmpty,
                  child: Text(
                    _textResult,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: appState.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  iconSize: 24,
                  icon: Icon(Icons.refresh_outlined, color: appState.isDarkTheme ? Colors.white : Colors.black),
                  tooltip: 'Clear inputs and result',
                  onPressed: () {
                    setState(() {
                      _heightController.clear();
                      _weightController.clear();
                      _bmiResult = 0;
                      _textResult = '';
                      _errorMessage = '';
                    });
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: appState.isDarkTheme ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: DropdownButton<String>(
                        value: appState.selectedLanguage,
                        items: languages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language['name'],
                            child: Row(
                              children: [
                                Text(language['flag']!),
                                const SizedBox(width: 8),
                                Text(language['name']!),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: _handleLanguageChange,
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          appState.toggleTheme();
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Icon(
                            appState.isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
                            key: ValueKey<bool>(appState.isDarkTheme),
                            color: appState.isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Icon(Icons.history, color: appState.isDarkTheme ? Colors.white : Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          if (_showError)
            Positioned(
              bottom: 0,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showError = !_showError;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: appState.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: appState.isDarkTheme ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}