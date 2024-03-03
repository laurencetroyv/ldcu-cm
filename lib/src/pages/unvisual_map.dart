import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/models/settings_model.dart';
import 'package:ldcu/src/pages/building_information.dart';
import 'package:ldcu/src/provider/settings_provider.dart';

class UnvisualMap extends ConsumerStatefulWidget {
  const UnvisualMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnvisualMapState();
}

class _UnvisualMapState extends ConsumerState<UnvisualMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.4861317, 124.6394635),
    zoom: 18,
  );

  void _onMarkerTapped(
    BuildContext context,
    String buildingName,
    String desc,
    List<Map<String, Object>> data,
    String mapSrc,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuildingInformation(
          data,
          name: buildingName,
          description: desc,
          mapSrc: mapSrc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = ref.read(settingsProvider);
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          style: settings.mapThemeMode ? darkMap : lightMap,
          mapType: settings.mapType ? MapType.hybrid : MapType.normal,
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          buildingsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {
            Marker(
              markerId: const MarkerId('lcc'),
              position: const LatLng(8.48538, 124.63889),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kLccBuildingName,
                  kLccBuildingDesc,
                  lccData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('sac'),
              position: const LatLng(8.48486, 124.63890),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kSacBuildingName,
                  kSacBuildingDec,
                  sacData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('rodelsa'),
              position: const LatLng(8.48599, 124.63902),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kRodelsaName,
                  kRodelsaDesc,
                  rhData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('wac'),
              position: const LatLng(8.48676, 124.63911),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kWacBuildingName,
                  kWacBuildingDesc,
                  wacData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('nac'),
              position: const LatLng(8.48705, 124.63954),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kNacBuildingName,
                  kNacBuildingDesc,
                  nacData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('lib'),
              position: const LatLng(8.48570, 124.63950),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kLibraryName,
                  kLibraryDesc,
                  [],
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
            Marker(
              markerId: const MarkerId('eac'),
              position: const LatLng(8.48649, 124.63958),
              onTap: () {
                _onMarkerTapped(
                  context,
                  kEacBuildingName,
                  kEacBuildingDesc,
                  eacData,
                  "assets/liceo-campus-map.gltf",
                );
              },
            ),
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
