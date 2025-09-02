import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _keyIsLoggedIn = "is_logged_in";

  final SharedPreferences prefs;

  SharedPrefsHelper(this.prefs);

  Future<void> setLoggedIn(bool value) async {
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}

final sharedPrefsProvider = Provider<SharedPrefsHelper>((ref) {
  throw UnimplementedError();
});
