import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ldcu/src/pages/visual_map.dart';

class BuildingInformation extends ConsumerStatefulWidget {
  const BuildingInformation(
    this.data, {
    super.key,
    required this.name,
    required this.description,
  });
  final String name;
  final String description;
  final List<Map<String, Object>> data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuildingInformationState();
}

class _BuildingInformationState extends ConsumerState<BuildingInformation> {
  final _searchController = SearchController();

  String get search => _searchController.text;

  @override
  Widget build(BuildContext context) {
    final sortedData = widget.data;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.justify,
              ),
              const Gap(16),
              FilledButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VisualMap()),
                    );
                  },
                  child: const Text("View Campus 3D Map")),
              const Gap(16),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedData.length,
                  itemBuilder: (context, index) {
                    final item = sortedData[index];
                    bool hasCode = item['code'] != null;
                    return ListTile(
                      title: Text(item['name'] as String),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasCode)
                            Text("Room code: ${item['code'] as String}"),
                          Text("floor: ${item['floor'] as int}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
