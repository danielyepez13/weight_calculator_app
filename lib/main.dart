import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Weight Calculator',
          debugShowCheckedModeBanner: false,
          theme: appState.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: const HomeScreen(),
        );
      },
    );
  }
}