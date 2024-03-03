import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ldcu/main.dart';
import 'package:ldcu/src/models/settings_model.dart';

class SwitchMapNotifier extends StateNotifier<SettingsModel> {
  static final settingsBox = Hive.box<SettingsModel>('settings');
  SwitchMapNotifier() : super(SettingsModel.initialSettings());

  void switchMap(bool value) {
    state = state.copyWith(isMap3D: value);
    settingsBox.put('settings', state);
    prefs.setString('settings', state.toString());
  }

  void switchTheme(bool value) {
    state = state.copyWith(isDarkMode: value);
    settingsBox.put('settings', state);
    prefs.setString('settings', state.toString());
  }

  void switchMapTheme(bool value) {
    state = state.copyWith(mapThemeMode: value);
    settingsBox.put('settings', state);
    prefs.setString('settings', state.toString());
  }

  void switchMapType(bool value) {
    state = state.copyWith(mapType: value);
    settingsBox.put('settings', state);
    prefs.setString('settings', state.toString());
  }

  void setState(SettingsModel settings) {
    state = settings;
  }
}

final settingsProvider =
    StateNotifierProvider<SwitchMapNotifier, SettingsModel>((ref) {
  return SwitchMapNotifier();
});
