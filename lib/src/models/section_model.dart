import 'dart:convert';

import 'package:hive/hive.dart';

part 'section_model.g.dart';

@HiveType(typeId: 1)
class SectionModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String prof;
  @HiveField(3)
  final String building;
  @HiveField(4)
  final String roomCode;
  @HiveField(5)
  final String day;
  @HiveField(6)
  final String startTime;
  @HiveField(7)
  final String endTime;

  SectionModel({
    required this.name,
    required this.code,
    required this.prof,
    required this.building,
    required this.roomCode,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory SectionModel.fromHive(Map<String, dynamic> json) {
    return SectionModel(
      name: json['name'],
      code: json['code'],
      prof: json['prof'],
      building: json['building'],
      roomCode: json['roomCode'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'name': name,
      'code': code,
      'prof': prof,
      'building': building,
      'roomCode': roomCode,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  SectionModel copyWith({
    String? name,
    String? code,
    String? prof,
    String? building,
    String? roomCode,
    String? day,
    String? startTime,
    String? endTime,
  }) {
    return SectionModel(
      name: name ?? this.name,
      code: code ?? this.code,
      prof: prof ?? this.prof,
      building: building ?? this.building,
      roomCode: roomCode ?? this.roomCode,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() {
    return 'SectionModel(name: $name, code: $code, prof: $prof, building: $building, roomCode: $roomCode, day: $day startTime: $startTime, endTime: $endTime)';
  }

  factory SectionModel.fromJson(String source) =>
      SectionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      name: map['name'],
      code: map['code'],
      prof: map['prof'],
      building: map['building'],
      roomCode: map['roomCode'],
      day: map['day'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
