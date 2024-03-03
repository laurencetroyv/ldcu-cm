import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:ldcu/src/models/section_model.dart';

class ScheduleNotifier extends StateNotifier<List<SectionModel>> {
  static final scheduleBox = Hive.box<SectionModel>('schedule');
  ScheduleNotifier() : super([]);

  void addSection(SectionModel section) {
    state = [...state, section];
    Hive.box<SectionModel>('schedule').add(section);
  }

  void removeSection(SectionModel section) {
    state = state.where((s) => s != section).toList();
    Hive.box<SectionModel>('schedule').delete(section);
  }

  void clear() {
    state = [];
    Hive.box<SectionModel>('schedule').clear();
  }

  Future<List<SectionModel>> getSubjects() async {
    final schedules = scheduleBox.values.toList();
    return schedules;
  }

  void setState(List<SectionModel> section) {
    state = section;
  }
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<SectionModel>>((ref) {
  return ScheduleNotifier();
});
