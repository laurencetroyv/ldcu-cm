import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ldcu/src/models/settings_model.dart';
import 'package:ldcu/src/pages/tab_bar_navigation.dart';
import 'package:ldcu/src/provider/settings_provider.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  await BoxCollection.open('ldcu', {'settings', 'course'});

  Hive.registerAdapter(SettingsModelAdapter());

  Hive.openBox<SettingsModel>('settings');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(settingsProvider).isDarkMode;

    return FutureBuilder(
      future: fetchData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

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
      },
    );
  }

  Future<bool> fetchData(WidgetRef ref) async {
    final settingPrefs = prefs.getString("settings");
    if (settingPrefs == null) {
      await prefs.setString(
          "settings", SettingsModel.initialSettings().toString());
    } else {
      ref
          .read(settingsProvider.notifier)
          .setState(SettingsModel.fromJson(settingPrefs));
    }
    return true;
  }
}
