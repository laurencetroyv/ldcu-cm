import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o3d/o3d.dart';

class VisualMap extends ConsumerStatefulWidget {
  const VisualMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisualMapState();
}

class _VisualMapState extends ConsumerState<VisualMap> {
  final _o3d = O3DController();
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: SearchAnchor(
            searchController: _searchController,
            headerTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
            isFullScreen: false,
            viewBackgroundColor: const Color(0xFF8E869C),
            builder: (context, controller) {
              return SearchBar(
                leading: const Icon(Icons.search, color: Color(0xFF8E869C)),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                controller: controller,
                onTap: () => controller.openView(),
                textStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
              return [];
            },
          ),
        ),
        body: O3D.asset(
          touchAction: TouchAction.none,
          controller: _o3d,
          src: "assets/visual_map.gltf",
        ),
      ),
    );
  }
}
