import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:o3d/o3d.dart';

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

  @override
  Widget build(BuildContext context) {
    final sortedData = widget.data;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAnchor(
                searchController: _searchController,
                headerTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
                isFullScreen: false,
                builder: (context, controller) {
                  return SearchBar(
                    leading: const Icon(
                      Icons.search,
                    ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: controller,
                    onTap: () => controller.openView(),
                    textStyle: const MaterialStatePropertyAll(
                      TextStyle(
                        fontWeight: FontWeight.w500,
                        // color: Colors.white,
                      ),
                    ),
                    shape: const MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide.none,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 48,
                      maxHeight: 48,
                    ),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return widget.data
                      .where((data) => data
                          .toString()
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()))
                      .map((item) {
                    final name = item['name'] as String;
                    return ListTile(
                      title: Text(name),
                      onTap: () {},
                    );
                  }).toList();
                },
              ),
              const Gap(16),
              Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
              Text(widget.description,
                  style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.justify,),
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
