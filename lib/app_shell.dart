import 'package:flutter/material.dart';

import 'package:thinkory/Pages/GamesPage.dart';
import 'package:thinkory/Pages/HomePage.dart';
import 'package:thinkory/Pages/ProfilePage.dart';
import 'package:thinkory/Pages/RankingsPage.dart';

import 'package:thinkory/Core/widgets/bottom_navigation.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Homepage(),
    Gamespage(),
    Rankingspage(),
    Profilepage(),
  ];

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: selectedIndex, children: pages),
      ),

      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
