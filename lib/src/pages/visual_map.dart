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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: O3D.asset(
          touchAction: TouchAction.none,
          controller: _o3d,
          src: "assets/visual_map.gltf",
        ),
      ),
    );
  }
}
