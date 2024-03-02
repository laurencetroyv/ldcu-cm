import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/pages/unvisual_map.dart';
import 'package:ldcu/src/pages/visual_map.dart';
import 'package:ldcu/src/provider/switch_provider.dart';

import 'add_section.dart';
import 'settings.dart';

class TabBarNavigation extends ConsumerWidget {
  const TabBarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMap3D = ref.watch(switchMapProvider);

    return SafeArea(
      child: DefaultTabController(
        length: 6,
        initialIndex: 0,
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
                    MaterialPageRoute(builder: (context) => const AddSection()),
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
              Text(kMon),
              Text(kTue),
              Text(kWed),
              Text(kThu),
              Text(kFri),
              Text(kSat),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isMap3D ? const VisualMap() : const UnvisualMap(),
                ),
              );
            },
            child: Icon(isMap3D ? Icons.map : Icons.map_outlined),
          ),
        ),
      ),
    );
  }
}
