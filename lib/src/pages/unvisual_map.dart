import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:ldcu/src/constants/constants.dart';
import 'package:ldcu/src/function/request_destination.dart';
import 'package:ldcu/src/models/env_model.dart';
import 'package:ldcu/src/pages/building_information.dart';
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
  int _duration = 0;
  double _distance = 0;
  int _durationSinceEpoch = 0;

  Timer? _timer;
  bool timerStarted = false;

  @override
  Widget build(BuildContext context) {
    int durationSinceEpoch = _durationSinceEpoch;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            GoogleMap(
              cloudMapId: Env.cloudMapID,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              markers: _markers(ref),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            SearchContainer(
              _searchController,
              data: buildings,
              onTap: (value) {
                _searchController.closeView(value);
                _findBuilding(value);
              },
            ),
            if (timerStarted)
              Positioned(
                left: 16,
                bottom: 16,
                right: 88,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 16),
                      const Gap(4),
                      Text(
                        "Duration since started: ${durationSinceEpoch ~/ 60 == 0 ? null : "${durationSinceEpoch ~/ 60} min"} ${durationSinceEpoch % 60} sec",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() => timerStarted = !timerStarted);
                                _timer?.cancel();
                                _durationSinceEpoch = 0;
                                _removePolyLine();
                                _scaffoldMessage(
                                  "Navigation stopped, the time since started was: ${durationSinceEpoch ~/ 60 == 0 ? null : "${durationSinceEpoch ~/ 60} min"} ${durationSinceEpoch % 60} sec",
                                );
                              },
                              child: const Text("Stop"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      polylineId: id,
      color: const Color(0xFF89201a),
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _removePolyLine() {
    polylineCoordinates.clear();
    polylines.clear();
    setState(() {});
  }

  _scaffoldMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  _getPolyline(LatLng origin, LatLng destination) async {
    _removePolyLine();
    final request = requestDestination(origin, destination);

    final response = await http.post(
      request[0] as Uri,
      headers: request[1] as Map<String, String>,
      body: request[2],
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey("error")) {
        _scaffoldMessage(responseData['error']);
      } else if (responseData.containsKey("routes")) {
        String encoded =
            responseData['routes'][0]['polyline']['encodedPolyline'];
        final result = polylinePoints.decodePolyline(encoded);

        final durationString = responseData['routes'][0]['duration'] as String;

        _duration = int.parse(
          durationString.substring(0, durationString.length - 1),
        );

        _distance = responseData['routes'][0]['distanceMeters'];

        if (result.isEmpty) {
          _scaffoldMessage("No routes found");
        } else {
          for (PointLatLng point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          _addPolyLine();
        }
      } else {
        _scaffoldMessage(
          "No routes found. Something might be wrong with request data",
        );
      }
    } else {
      _scaffoldMessage(
        'Request failed with status: ${response.statusCode} | Response body: ${response.body}',
      );
    }
  }

  LatLngBounds getBounds(List<LatLng> points) {
    double south = points[0].latitude;
    double west = points[0].longitude;
    double north = points[0].latitude;
    double east = points[0].longitude;

    for (LatLng point in points) {
      south = south < point.latitude ? south : point.latitude;
      west = west < point.longitude ? west : point.longitude;
      north = north > point.latitude ? north : point.latitude;
      east = east > point.longitude ? east : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  Set<Marker> _markers(WidgetRef ref) {
    final origin = ref.read(userPositionProvider);
    return {
      Marker(
        markerId: const MarkerId('origin'),
        position: origin,
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
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

  void showTimeAndDistance(BuildContext context, String buildingName) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Going to $buildingName",
                  style: Theme.of(context).textTheme.titleLarge),
              Text(
                "${_duration ~/ 60} min (${(_distance / 1000).toStringAsFixed(2)} km)",
              ),
              Text(
                "Approximate time and distance from your current location. Click the 'Start' button to start navigating.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.justify,
              ),
              const Gap(8),
              FilledButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.only(left: 8, right: 10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => timerStarted = !timerStarted);

                  if (timerStarted) {
                    _timer = Timer.periodic(
                      const Duration(seconds: 1),
                      (timer) {
                        setState(() {
                          _durationSinceEpoch = timer.tick;
                        });
                      },
                    );
                  } else {
                    _timer?.cancel();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.navigation, size: 16),
                    const Gap(4),
                    Text(timerStarted ? "Cacnel" : "Start"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
                      _removePolyLine();
                      await _getPolyline(origin, destination);
                      LatLngBounds bounds = getBounds(polylineCoordinates);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                        _controller.future.then((controller) {
                          controller.animateCamera(
                            CameraUpdate.newLatLngBounds(
                              bounds,
                              50.0,
                            ),
                          );
                        });
                        showTimeAndDistance(context, buildingName);
                      });
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

  void _findBuilding(String value) {
    if (value == kLccBuildingName) {
      onMarkerTapped(
        context,
        kLccBuildingName,
        kLccBuildingDesc,
        lccData,
        "assets/liceo-campus-map.gltf",
        kLccImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48538, 124.63889),
      );
    } else if (value == kSacBuildingName) {
      onMarkerTapped(
        context,
        kSacBuildingName,
        kSacBuildingDec,
        sacData,
        "assets/liceo-campus-map.gltf",
        kSacImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48486, 124.63890),
      );
    } else if (value == kRodelsaName) {
      onMarkerTapped(
        context,
        kRodelsaName,
        kRodelsaDesc,
        rhData,
        "assets/liceo-campus-map.gltf",
        kRodelsaImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48599, 124.63902),
      );
    } else if (value == kWacBuildingName) {
      onMarkerTapped(
        context,
        kWacBuildingName,
        kWacBuildingDesc,
        wacData,
        "assets/liceo-campus-map.gltf",
        kWacImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48676, 124.63911),
      );
    } else if (value == kNacBuildingName) {
      onMarkerTapped(
        context,
        kNacBuildingName,
        kNacBuildingDesc,
        nacData,
        "assets/liceo-campus-map.gltf",
        kNacImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48705, 124.63954),
      );
    } else if (value == kLibraryName) {
      onMarkerTapped(
        context,
        kLibraryName,
        kLibraryDesc,
        [],
        "assets/liceo-campus-map.gltf",
        kLibraryImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48570, 124.63950),
      );
    } else if (value == kEacBuildingName) {
      onMarkerTapped(
        context,
        kEacBuildingName,
        kEacBuildingDesc,
        eacData,
        "assets/liceo-campus-map.gltf",
        kEacImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48649, 124.63958),
      );
    } else if (value == kCivilBuildingName) {
      onMarkerTapped(
        context,
        kCivilBuildingName,
        kCivilBuildingDesc,
        [],
        "assets/liceo-campus-map.gltf",
        kCivilImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.48473, 124.63906),
      );
    } else if (value == kChurchName) {
      onMarkerTapped(
        context,
        kChurchName,
        kChurchDesc,
        [],
        "assets/liceo-campus-map.gltf",
        kChurchImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.4852, 124.63932),
      );
    } else if (value == kCanteenName) {
      onMarkerTapped(
        context,
        kCanteenName,
        kCanteenDesc,
        [],
        "assets/liceo-campus-map.gltf",
        kCanteenImages,
        const LatLng(8.4861317, 124.6394635),
        const LatLng(8.4864, 124.63986),
      );
    }
  }
}
