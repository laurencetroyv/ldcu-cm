import 'dart:convert';

import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final bool isMap3D;

  @HiveField(2)
  final bool mapThemeMode;

  @HiveField(3)
  final bool mapType;

  const SettingsModel({
    required this.isDarkMode,
    required this.isMap3D,
    required this.mapThemeMode,
    required this.mapType,
  });

  factory SettingsModel.fromHive(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['isDarkMode'],
      isMap3D: json['isMap3D'],
      mapThemeMode: json['mapThemeMode'],
      mapType: json['mapType'],
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'isDarkMode': isDarkMode,
      'isMap3D': isMap3D,
      'mapThemeMode': mapThemeMode,
      'mapType': mapType,
    };
  }

  factory SettingsModel.initialSettings() {
    return const SettingsModel(
      isDarkMode: false,
      isMap3D: false,
      mapThemeMode: false,
      mapType: false,
    );
  }

  SettingsModel copyWith({
    bool? isDarkMode,
    bool? isMap3D,
    bool? mapThemeMode,
    bool? mapType,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isMap3D: isMap3D ?? this.isMap3D,
      mapThemeMode: mapThemeMode ?? this.mapThemeMode,
      mapType: mapType ?? this.mapType,
    );
  }

  @override
  String toString() =>
      'SettingsModel(isDarkMode: $isDarkMode, isMap3D: $isMap3D, mapThemeMode: $mapThemeMode, mapType: $mapType)';

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      isDarkMode: map['isDarkMode'] as bool,
      isMap3D: map['isMap3D'] as bool,
      mapThemeMode: map['mapThemeMode'] as bool,
      mapType: map['mapType'] as bool,
    );
  }
}
