import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ldcu/src/models/settings_model.dart';
import 'package:ldcu/src/provider/settings_provider.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsModel settings = ref.watch(settingsProvider);
    bool isDark = settings.isDarkMode;
    bool isMap3D = settings.isMap3D;
    bool isMapThemeMode = settings.mapThemeMode;
    bool isMapType = settings.mapType;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Settings', style: Theme.of(context).textTheme.titleSmall),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              const Text("General"),
              ListTile(
                leading: const Icon(Icons.contrast),
                title: const Text('Choose Theme'),
                subtitle: const Text('Choose between light and dark theme.'),
                onTap: () async {
                  _showMyDialog(
                    context,
                    title: "Choose Theme",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<bool>(
                          title: const Text('Light'),
                          value: false,
                          groupValue: isDark,
                          onChanged: (bool? value) {
                            ref
                                .read(settingsProvider.notifier)
                                .switchTheme(false);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<bool>(
                          title: const Text('Dark'),
                          value: true,
                          groupValue: isDark,
                          onChanged: (bool? value) {
                            ref
                                .read(settingsProvider.notifier)
                                .switchTheme(true);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text("Map", style: Theme.of(context).textTheme.titleSmall),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Choose Map'),
                subtitle: const Text('Choose between 2D and 3D map.'),
                onTap: () async {
                  _showMyDialog(
                    context,
                    title: "Choose Map",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<bool>(
                          title: const Text('2D'),
                          value: false,
                          groupValue: isMap3D,
                          onChanged: (bool? value) {
                            ref
                                .read(settingsProvider.notifier)
                                .switchMap(false);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<bool>(
                          title: const Text('3D'),
                          value: true,
                          groupValue: isMap3D,
                          onChanged: (bool? value) {
                            ref.read(settingsProvider.notifier).switchMap(true);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(8),
              if (!isMap3D)
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Choose Map Style'),
                  subtitle:
                      const Text('Choose between Hybrid and Normal style.'),
                  onTap: () async {
                    _showMyDialog(
                      context,
                      title: "Choose Map Style",
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Map Type"),
                          RadioListTile<bool>(
                            title: const Text('Hybrid'),
                            value: true,
                            groupValue: isMapType,
                            onChanged: (bool? value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .switchMapType(true);
                              Navigator.of(context).pop();
                            },
                          ),
                          RadioListTile<bool>(
                            title: const Text('Normal'),
                            value: false,
                            groupValue: isMapType,
                            onChanged: (bool? value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .switchMapType(false);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (!isMap3D && !isMapType)
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Choose Map Theme'),
                  subtitle: const Text('Choose between light and dark theme.'),
                  onTap: () async {
                    _showMyDialog(
                      context,
                      title: "Choose Map Theme",
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Map Theme"),
                          RadioListTile<bool>(
                            title: const Text('Light'),
                            value: false,
                            groupValue: isMapThemeMode,
                            onChanged: (bool? value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .switchMapTheme(false);
                              Navigator.of(context).pop();
                            },
                          ),
                          RadioListTile<bool>(
                            title: const Text('Dark'),
                            value: true,
                            groupValue: isMapThemeMode,
                            onChanged: (bool? value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .switchMapTheme(true);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
    BuildContext context, {
    required String title,
    required Widget child,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(title),
          content: child,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
