import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ldcu/src/pages/unvisual_map.dart';
import 'package:ldcu/src/provider/user_position.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          home: const UnvisualMap(),
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
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
