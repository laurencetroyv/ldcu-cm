import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o3d/o3d.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/models/section_model.dart';

class ScheduleInfo extends ConsumerStatefulWidget {
  const ScheduleInfo(this.section, {super.key});
  final SectionModel section;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleInfoState();
}

class _ScheduleInfoState extends ConsumerState<ScheduleInfo> {
  bool timerStarted = false;
  Timer? _timer;
  final _o3d = O3DController();

  @override
  Widget build(BuildContext context) {
    late Map<String, Object> buildingData;

    if (widget.section.building != kRodelsaName &&
        widget.section.building != kLccBuildingName) {
      buildingData = data.firstWhere(
        (d) => d['code'] == widget.section.roomCode,
      );
    } else {
      buildingData = data.firstWhere(
        (d) => d['name'] == widget.section.roomCode,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.section.name),
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text('Code'),
              subtitle: Text(widget.section.code),
            ),
            ListTile(
              title: const Text('Professor'),
              subtitle: Text(widget.section.prof),
            ),
            ListTile(
              title: const Text('Building'),
              subtitle: Text(widget.section.building),
            ),
            ListTile(
              title: const Text('Room'),
              subtitle: Text("${buildingData['name']}"),
            ),
            ListTile(
              title: const Text('Day'),
              subtitle: Text(widget.section.day),
            ),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(widget.section.startTime),
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(widget.section.endTime),
            ),
            Expanded(
              child: O3D.asset(
                controller: _o3d,
                src: "assets/liceo-campus-map.gltf",
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            setState(() => timerStarted = !timerStarted);

            if (timerStarted) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                print(timer.tick);
              });

              await _showMyDialog(
                context,
                title: 'Timer',
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Timer is running'),
                    SizedBox(height: 8),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
          icon: const Icon(Icons.directions),
          label: Text(timerStarted ? 'Stop Timer' : 'Start Timer'),
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(title),
          content: child,
          actions: <Widget>[
            TextButton(
              child: const Text('Stop Timer'),
              onPressed: () {
                setState(() => timerStarted = false);
                Navigator.of(context).pop();
                _timer?.cancel();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Timer stopped: ${_timer?.tick} seconds'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
