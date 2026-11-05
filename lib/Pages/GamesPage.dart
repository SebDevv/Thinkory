import 'package:flutter/material.dart';

class Gamespage extends StatefulWidget {
  const new({super.key});

  @override
  State<Gamespage> createState() => _GamespageState();
}

class _GamespageState extends State<Gamespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Game Page")));
  }
}
