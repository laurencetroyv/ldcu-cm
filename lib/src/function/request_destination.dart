import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ldcu/src/models/env_model.dart';

List<Object> requestDestination(
  LatLng origin,
  LatLng destination,
) {
  final reqBody = {
    "origin": {
      "location": {
        "latLng": {
          "latitude": origin.latitude,
          "longitude": origin.longitude,
        }
      }
    },
    "destination": {
      "location": {
        "latLng": {
          "latitude": destination.latitude,
          "longitude": destination.longitude
        }
      }
    },
    "travelMode": "DRIVE",
    "routingPreference": "ROUTING_PREFERENCE_UNSPECIFIED",
    "computeAlternativeRoutes": false,
    "routeModifiers": {
      "avoidTolls": false,
      "avoidHighways": false,
      "avoidFerries": false
    },
    "units": "IMPERIAL"
  };

  const apiUrl = 'https://routes.googleapis.com/directions/v2:computeRoutes';
  final apiKey = Env.googleMapApiKey;

  final headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask':
        'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
  };

  return [Uri.parse(apiUrl), headers, jsonEncode(reqBody)];
}
