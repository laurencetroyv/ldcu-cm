import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ldcu/src/provider/switch_provider.dart';
import 'package:ldcu/src/provider/theme_provider.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMap3D = ref.watch(switchMapProvider);
    bool isDark = ref.watch(themeProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                  'Switch Theme to ${isDark ? 'Light Mode' : 'Dark Mode'}'),
              trailing: Switch(
                value: ref.watch(themeProvider),
                onChanged: (value) {
                  ref.read(themeProvider.notifier).switchTheme(value);
                },
              ),
            ),
            ListTile(
              title: Text('Switch Map to ${isMap3D ? '2D' : '3D'}'),
              trailing: Switch(
                value: ref.watch(switchMapProvider),
                onChanged: (value) {
                  ref.read(switchMapProvider.notifier).switchMap(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
