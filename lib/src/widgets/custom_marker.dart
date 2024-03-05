import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerIcon(String assets) async {
  Uint8List markerIconBytes =
      await getBytesFromAsset(assets);
  return BitmapDescriptor.fromBytes(markerIconBytes);
}

Future<Uint8List> getBytesFromAsset(String path) async {
  ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}
