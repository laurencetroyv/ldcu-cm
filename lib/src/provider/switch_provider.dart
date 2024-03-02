import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchMapNotifier extends StateNotifier<bool> {
  SwitchMapNotifier(): super(false);
  
  void switchMap(bool value) {
    state = value;
  }
}

final switchMapProvider = StateNotifierProvider<SwitchMapNotifier, bool>((ref) {
  return SwitchMapNotifier();
});