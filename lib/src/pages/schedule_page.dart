import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/models/section_model.dart';
import 'package:ldcu/src/pages/schedule_info.dart';
import 'package:ldcu/src/provider/schedule_provider.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage(this.day, {super.key});
  final String day;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SchedulePageState();
}

class SchedulePageState extends ConsumerState<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _getSchedule(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          late List<SectionModel> section;

          if (snapshot.hasData) {
            section = snapshot.data as List<SectionModel>;
            section = section.where((s) {
              final day = s.day.substring(0, 3);

              return day == widget.day;
            }).toList();
          } else {
            section = ref.read(scheduleProvider);
          }

          return Scaffold(
            body: section.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity),
                      SvgPicture.asset(
                        'assets/no-class.svg',
                        height: 200,
                        width: 200,
                      ),
                      Text(
                        "No classes today",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: section.length,
                    itemBuilder: (context, index) {
                      final startTime = section[index].startTime;
                      final endTime = section[index].endTime;
                      final building = section[index].building;
                      final roomCode = section[index].roomCode;
                      late int floor;
                      late List<Map<String, Object>> data;

                      switch (building) {
                        case kLccBuildingName:
                          data = lccData;
                          break;
                        case kSacBuildingName:
                          data = sacData;
                          break;
                        case kWacBuildingName:
                          data = wacData;
                          break;
                        case kNacBuildingName:
                          data = nacData;
                          break;
                        case kEacBuildingName:
                          data = eacData;
                          break;
                        case kRodelsaName:
                          data = rhData;
                          break;
                      }

                      if (building != kRodelsaName &&
                          building != kLccBuildingName) {
                        floor = data
                            .where((d) => d['code'] == roomCode)
                            .map((d) => d['floor'])
                            .first as int;
                      } else {
                        floor = data
                            .where((d) => d['name'] == roomCode)
                            .map((d) => d['floor'])
                            .first as int;
                      }

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScheduleInfo(section[index]),
                            ),
                          );
                        },
                        leading: Text(section[index].code),
                        title: Text(section[index].name),
                        subtitle: Text(
                            "$startTime-$endTime | $building, Floor: $floor"),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Future<List<SectionModel>> _getSchedule(WidgetRef ref) async {
    final schedules = await ref.read(scheduleProvider.notifier).getSubjects();
    ref.read(scheduleProvider.notifier).setState(schedules);
    return schedules;
  }
}
