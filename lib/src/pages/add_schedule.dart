import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/models/section_model.dart';
import 'package:ldcu/src/provider/schedule_provider.dart';

class AddSchedule extends ConsumerStatefulWidget {
  const AddSchedule({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddScheduleState();
}

class _AddScheduleState extends ConsumerState<AddSchedule> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _profController = TextEditingController();
  final _buildingController = TextEditingController();
  final _roomController = TextEditingController();
  final _dayController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  String get _name => _nameController.text;
  String get _code => _codeController.text;
  String get _prof => _profController.text;
  String get _building => _buildingController.text;
  String get _room => _roomController.text;
  String get _day => _dayController.text;
  String get _startTime => _startTimeController.text;
  String get _endTime => _endTimeController.text;

  final buildingsMenu =
      buildings.map((e) => DropdownMenuEntry(value: e, label: e)).toList();

  final dayMenu =
      days.map((e) => DropdownMenuEntry(value: e, label: e)).toList();

  List<Map<String, Object>> data = [];
  List<DropdownMenuEntry> roomMenu = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(kAddSchedule),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (_building.isEmpty) {
                  _error(context, "Building is required");
                }
                if (_room.isEmpty) {
                  _error(context, "Room is required");
                }
                if (_day.isEmpty) {
                  _error(context, "Day is required");
                }
                if (_startTime.isEmpty) {
                  _error(context, "Start time is required");
                }
                if (_endTime.isEmpty) {
                  _error(context, "End time is required");
                }

                if (_formKey.currentState!.validate()) {
                  if (_startTime.split(":").first ==
                      _endTime.split(":").first) {
                    _error(
                        context, "Start time and end time cannot be the same");
                  } else if (double.parse(_startTime.split(":").first) >=
                      double.parse(_endTime.split(":").first)) {
                    _error(
                        context, "Start time cannot be greater than end time");
                  } else {
                    SectionModel section = SectionModel(
                      name: _name,
                      code: _code,
                      prof: _prof,
                      building: _building,
                      roomCode: _room,
                      day: _day,
                      startTime: _startTime,
                      endTime: _endTime,
                    );

                    ref.read(scheduleProvider.notifier).addSection(section);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: kName,
                      hintText: kNameHint,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Subject name is required";
                      }
                      return null;
                    }),
                const Gap(16),
                TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: kCode,
                      hintText: kCodeHint,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Subject code is required";
                      }
                      return null;
                    }),
                const Gap(16),
                TextField(
                  controller: _profController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: kProf,
                    hintText: kProfHint,
                  ),
                ),
                const Gap(16),
                DropdownMenu<String>(
                  controller: _buildingController,
                  dropdownMenuEntries: buildingsMenu,
                  label: const Text("Select Building"),
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (value) => _settingRoomValue(value),
                ),
                const Gap(16),
                DropdownMenu(
                  controller: _roomController,
                  dropdownMenuEntries: roomMenu,
                  label: const Text(kRoom),
                  expandedInsets: EdgeInsets.zero,
                ),
                const Gap(16),
                DropdownMenu<String>(
                  controller: _dayController,
                  dropdownMenuEntries: dayMenu,
                  label: const Text("Select Day"),
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (value) {
                    _dayController.text = value!;
                  },
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: kStartTime,
                          hintText: kStartTimeHint,
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            barrierDismissible: false,
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            _startTimeController.text =
                                "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: TextField(
                        controller: _endTimeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: kEndTime,
                          hintText: kEndTimeHint,
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          final date = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (date != null) {
                            _endTimeController.text =
                                "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _settingRoomValue(value) {
    switch (value!) {
      case kLccBuildingName:
        setState(() {
          roomMenu = lccData
              .map((e) {
                final name = e['name'] as String;
                return DropdownMenuEntry(
                    value: e['name'],
                    label: name.substring(
                        0, name.length >= 64 ? 64 : name.length));
              })
              .toList()
              .toSet()
              .toList();
          data = lccData;
        });
        break;
      case kEacBuildingName:
        setState(() {
          roomMenu = eacData
              .map((e) {
                final name = e['name'] as String;
                final isGreater = name.length >= 64;
                return DropdownMenuEntry(
                    value: e['code'],
                    label:
                        "${e['code']} | ${name.substring(0, isGreater ? 64 : name.length)}${isGreater ? '...' : ''}");
              })
              .toList()
              .toSet()
              .toList();
          data = eacData;
        });
        break;
      case kNacBuildingName:
        setState(() {
          roomMenu = nacData
              .map((e) {
                final name = e['name'] as String;
                final isGreater = name.length >= 64;
                return DropdownMenuEntry(
                    value: e['code'],
                    label:
                        "${e['code']} | ${name.substring(0, isGreater ? 64 : name.length)}${isGreater ? '...' : ''}");
              })
              .toList()
              .toSet()
              .toList();
          data = nacData;
        });
        break;
      case kRodelsaName:
        setState(() {
          roomMenu = rhData
              .map((e) {
                final name = e['name'] as String;
                final isGreater = name.length >= 64;
                return DropdownMenuEntry(
                    value: e['name'],
                    label:
                        "${name.substring(0, isGreater ? 64 : name.length)}${isGreater ? '...' : ''}");
              })
              .toList()
              .toSet()
              .toList();
          data = rhData;
        });
        break;

      case kSacBuildingName:
        setState(() {
          roomMenu = sacData
              .map((e) {
                final name = e['name'] as String;
                final isGreater = name.length >= 64;
                return DropdownMenuEntry(
                    value: e['code'],
                    label:
                        "${e['code']} | ${name.substring(0, isGreater ? 64 : name.length)}${isGreater ? '...' : ''}");
              })
              .toList()
              .toSet()
              .toList();
          data = sacData;
        });
        break;
      case kWacBuildingName:
        setState(() {
          roomMenu = wacData
              .map((e) {
                final name = e['name'] as String;
                final isGreater = name.length >= 42;
                return DropdownMenuEntry(
                    value: e['code'],
                    label:
                        "${e['code']} | ${name.substring(0, isGreater ? 42 : name.length)}${isGreater ? '...' : ''}");
              })
              .toList()
              .toSet()
              .toList();
          data = wacData;
        });
        break;
    }
    _roomController.clear();
  }

  void _error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
