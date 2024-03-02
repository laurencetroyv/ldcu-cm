import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ldcu/src/pages/tab_bar_navigation.dart';
import 'package:ldcu/src/provider/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeProvider);

    return MaterialApp(
      home: const TabBarNavigation(),
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: const Color(0xFF89201a),
              secondary: const Color(0xFF89201a),
            ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: const Color(0xFF89201a),
              secondary: const Color(0xFF89201a),
            ),
      ),
    );
  }
}
