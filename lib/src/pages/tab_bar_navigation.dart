import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/pages/schedule_page.dart';
import 'package:ldcu/src/pages/unvisual_map.dart';
import 'package:ldcu/src/pages/visual_map.dart';
import 'package:ldcu/src/provider/settings_provider.dart';

import 'add_schedule.dart';
import 'settings.dart';

class TabBarNavigation extends ConsumerWidget {
  const TabBarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMap3D = ref.watch(settingsProvider).isMap3D;

    int currentDay = DateTime.now().weekday - 1;

    return SafeArea(
      child: DefaultTabController(
        length: 6,
        initialIndex: currentDay > 6 ? 0 : currentDay - 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(kAppName),
            bottom: const TabBar(
              tabs: [
                Tab(text: kMon),
                Tab(text: kTue),
                Tab(text: kWed),
                Tab(text: kThu),
                Tab(text: kFri),
                Tab(text: kSat),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddSchedule()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              SchedulePage(kMon),
              SchedulePage(kTue),
              SchedulePage(kWed),
              SchedulePage(kThu),
              SchedulePage(kFri),
              SchedulePage(kSat),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF89201a),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      isMap3D ? const VisualMap() : const UnvisualMap(),
                ),
              );
            },
            child: Icon(
              isMap3D ? Icons.map : Icons.map_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
