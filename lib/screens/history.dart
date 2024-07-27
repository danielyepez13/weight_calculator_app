import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentTranslations =
        appState.translations[appState.selectedLanguage]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentTranslations['history']!,
          style: TextStyle(
            fontSize: 32,
            color: appState.isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: appState.history.isNotEmpty ? [
          IconButton(
            icon: Icon(Icons.delete,
                color: appState.isDarkTheme ? Colors.white : Colors.black),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(currentTranslations['confirm_delete']!),
                    content:
                        Text(currentTranslations['confirm_delete_message']!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(currentTranslations['cancel']!),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(currentTranslations['delete']!),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete == true) {
                appState.clearHistory();
              }
            },
          ),
        ] : null,
      ),
      backgroundColor: appState.isDarkTheme ? Colors.black : Colors.white,
      body: appState.history.isEmpty
          ? Center(
              child: Text(
                currentTranslations['history_no_available']!,
                style: TextStyle(
                  fontSize: 24,
                  color: appState.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            )
          : ListView.builder(
              itemCount: appState.history.length,
              itemBuilder: (context, index) {
                final entry = appState.history[index];
                return ListTile(
                  title: Text(
                    '${currentTranslations['height']}: ${entry['height']} m, ${currentTranslations['weight']}: ${entry['weight']} kg, BMI: ${entry['bmi']}',
                    style: TextStyle(
                      color: appState.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
