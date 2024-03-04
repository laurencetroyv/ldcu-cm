import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:o3d/o3d.dart';

import 'package:ldcu/src/widgets/search_container.dart';

class BuildingInformation extends ConsumerStatefulWidget {
  const BuildingInformation(
    this.data, {
    super.key,
    required this.name,
    required this.description,
    required this.mapSrc,
  });
  final String name;
  final String description;
  final List<Map<String, Object>> data;
  final String mapSrc;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuildingInformationState();
}

class _BuildingInformationState extends ConsumerState<BuildingInformation> {
  final _searchController = SearchController();
  final _o3d = O3DController();

  String get search => _searchController.text;

  @override
  Widget build(BuildContext context) {
    final sortedData = widget.data;

    final data = sortedData.where((data) {
      return data.toString().toLowerCase().contains(search.toLowerCase());
    }).map((item) {
      final name = item['name'] as String;
      return name;
    }).toList();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  const Gap(8),
                  SearchContainer(_searchController, data: data),
                ],
              ),
              const Gap(16),
              Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.justify,
              ),
              const Gap(16),
              Expanded(
                flex: 2,
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
                      onTap: () {},
                    );
                  },
                ),
              ),
              Expanded(
                child: O3D.asset(
                  controller: _o3d,
                  src: widget.mapSrc,
                  cameraOrbit: CameraOrbit(150, 70, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
