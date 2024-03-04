import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserPositionNotifier extends StateNotifier<LatLng> {
  UserPositionNotifier() : super(const LatLng(0, 0));

  void setUserPosition(LatLng position) {
    state = position;
  }
}

final userPositionProvider =
    StateNotifierProvider<UserPositionNotifier, LatLng>((ref) {
  return UserPositionNotifier();
});
