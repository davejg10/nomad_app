import 'package:flutter/material.dart';
import 'package:nomad/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF141A3C),
        ),
        scaffoldBackgroundColor: const Color(0xFF141A3C),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}