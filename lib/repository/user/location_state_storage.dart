import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locationSwitchStorage = StateNotifierProvider<LocationSwitchNotifier, bool>((ref) {
  return LocationSwitchNotifier();
});

class LocationSwitchNotifier extends StateNotifier<bool> {
  static const _key = 'location_switch';

  LocationSwitchNotifier() : super(false) {
    _loadSwitchState(); // load on init
  }

  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool(_key) ?? false;
    state = savedValue;
  }

  Future<void> setSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    state = value;
  }
}
