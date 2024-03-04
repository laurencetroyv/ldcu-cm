import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/models/env_model.dart';
import 'package:ldcu/src/models/settings_model.dart';
import 'package:ldcu/src/pages/building_information.dart';
import 'package:ldcu/src/provider/settings_provider.dart';
import 'package:ldcu/src/provider/user_position.dart';
import 'package:ldcu/src/widgets/search_container.dart';

class UnvisualMap extends ConsumerStatefulWidget {
  const UnvisualMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnvisualMapState();
}

class _UnvisualMapState extends ConsumerState<UnvisualMap> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<String> images;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.4861317, 124.6394635),
    zoom: 18,
  );

  final _searchController = SearchController();

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = Env.googleMapApiKey;

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = ref.read(settingsProvider);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            GoogleMap(
              cloudMapId: Env.cloudMapID,
              rotateGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: settings.mapType ? MapType.hybrid : MapType.normal,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: false,
              buildingsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              compassEnabled: true,
              markers: _markers(),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            SearchContainer(_searchController, data: buildings)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF89201a),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(LatLng origin, LatLng destination) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    print(result);
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  Set<Marker> _markers() {
    final origin = ref.read(userPositionProvider);
    return {
      Marker(
        markerId: const MarkerId('origin'),
        position: origin,
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: const MarkerId('lcc'),
        position: const LatLng(8.48538, 124.63889),
        onTap: () {
          setState(() {
            images = kLccImages;
          });
          onMarkerTapped(
            context,
            kLccBuildingName,
            kLccBuildingDesc,
            lccData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48538, 124.63889),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('sac'),
        position: const LatLng(8.48486, 124.63890),
        onTap: () {
          setState(() {
            images = kSacImages;
          });
          onMarkerTapped(
            context,
            kSacBuildingName,
            kSacBuildingDec,
            sacData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48486, 124.63890),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('rodelsa'),
        position: const LatLng(8.48599, 124.63902),
        onTap: () {
          setState(() {
            images = kRodelsaImages;
          });
          onMarkerTapped(
            context,
            kRodelsaName,
            kRodelsaDesc,
            rhData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48599, 124.63902),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('wac'),
        position: const LatLng(8.48676, 124.63911),
        onTap: () {
          setState(() {
            images = kWacImages;
          });
          onMarkerTapped(
            context,
            kWacBuildingName,
            kWacBuildingDesc,
            wacData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48676, 124.63911),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('nac'),
        position: const LatLng(8.48705, 124.63954),
        onTap: () {
          setState(() {
            images = kNacImages;
          });
          onMarkerTapped(
            context,
            kNacBuildingName,
            kNacBuildingDesc,
            nacData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48705, 124.63954),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('lib'),
        position: const LatLng(8.48570, 124.63950),
        onTap: () {
          setState(() {
            images = kLibraryImages;
          });
          onMarkerTapped(
            context,
            kLibraryName,
            kLibraryDesc,
            [],
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48570, 124.63950),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('eac'),
        position: const LatLng(8.48649, 124.63958),
        onTap: () {
          setState(() {
            images = kEacImages;
          });
          onMarkerTapped(
            context,
            kEacBuildingName,
            kEacBuildingDesc,
            eacData,
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48649, 124.63958),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('engineering'),
        position: const LatLng(8.48473, 124.63906),
        onTap: () {
          setState(() {
            images = kCivilImages;
          });
          onMarkerTapped(
            context,
            kCivilBuildingName,
            kCivilBuildingDesc,
            [],
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.48473, 124.63906),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('church'),
        position: const LatLng(8.4852, 124.63932),
        onTap: () {
          setState(() {
            images = kChurchImages;
          });
          onMarkerTapped(
            context,
            kChurchName,
            kChurchDesc,
            [],
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.4852, 124.63932),
          );
        },
      ),
      Marker(
        markerId: const MarkerId('canteen'),
        position: const LatLng(8.4864, 124.63986),
        onTap: () {
          setState(() {
            images = kCanteenImages;
          });
          onMarkerTapped(
            context,
            kCanteenName,
            kCanteenDesc,
            [],
            "assets/liceo-campus-map.gltf",
            images,
            origin,
            const LatLng(8.4864, 124.63986),
          );
        },
      ),
    };
  }

  void onMarkerTapped(
    BuildContext context,
    String buildingName,
    String desc,
    List<Map<String, Object>> data,
    String mapSrc,
    List<String> images,
    LatLng origin,
    LatLng destination,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(buildingName, style: Theme.of(context).textTheme.titleLarge),
              Text(
                desc,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.justify,
              ),
              const Gap(8),
              Row(
                children: [
                  FilledButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(8, 0, 10, 0),
                      ),
                    ),
                    onPressed: () async {
                      await _getPolyline(origin, destination);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.directions, size: 16),
                        Gap(4),
                        Text("Directions"),
                      ],
                    ),
                  ),
                  const Gap(4),
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.only(left: 8, right: 10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.navigation, size: 16),
                        Gap(4),
                        Text("Start"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
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
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.info, size: 16),
                              Gap(4),
                              Text("Building Information"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(8),
              if (images.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 100,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
