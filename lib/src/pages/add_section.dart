import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ldcu/src/constants/add_section_constants.dart';

class AddSection extends ConsumerWidget {
  const AddSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: const Text(kAddSection),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kName,
                  hintText: kNameHint,
                ),
              ),
              const Gap(16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kCode,
                  hintText: kCodeHint,
                ),
              ),
              const Gap(16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kProf,
                  hintText: kProfHint,
                ),
              ),
              const Gap(16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kRoom,
                  hintText: kRoomHint,
                ),
              ),
              const Gap(16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kFloor,
                  hintText: kFloorHint,
                ),
              ),
              const Gap(16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: kBuilding,
                  hintText: kBuildingHint,
                ),
                onTap: () {
                  // Open the map to select the building
                },
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: kStartTime,
                        hintText: kStartTimeHint,
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                      },
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: kEndTime,
                        hintText: kEndTimeHint,
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
