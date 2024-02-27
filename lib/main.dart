import 'package:flutter/material.dart';

import 'package:ldcu/src/pages/tab_bar_navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TabBarNavigation(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: const Color(0xFF89201a),
              secondary: const Color(0xFF89201a),
            ),
      ),
    );
  }
}
