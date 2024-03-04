import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ldcu/src/models/section_model.dart';
import 'package:ldcu/src/models/settings_model.dart';
import 'package:ldcu/src/pages/tab_bar_navigation.dart';
import 'package:ldcu/src/provider/settings_provider.dart';
import 'package:ldcu/src/provider/user_position.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  await BoxCollection.open('ldcu', {'settings', 'schedule'});

  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(SectionModelAdapter());

  Hive.openBox<SettingsModel>('settings');
  Hive.openBox<SectionModel>('schedule');

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

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text("Error: ${snapshot.error}"),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      fetchData(ref);
                    },
                    child: const Text("Retry"),
                  ),
                ],
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
    final position = await _determinePosition();
    ref
        .read(userPositionProvider.notifier)
        .setUserPosition(LatLng(position.latitude, position.longitude));
    return true;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
