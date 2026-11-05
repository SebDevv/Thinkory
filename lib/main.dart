import 'package:flutter/material.dart';
import 'package:thinkory/app_shell.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const ThinkoryApp());
}

class ThinkoryApp extends StatefulWidget {
  const ThinkoryApp({super.key});

  @override
  State<ThinkoryApp> createState() => _ThinkoryAppState();
}

class _ThinkoryAppState extends State<ThinkoryApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeMode == ThemeMode.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thinkory',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: AppShell(isDarkMode: isDarkMode, onToggleTheme: _toggleTheme),
    );
  }
}
