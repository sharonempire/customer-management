import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _keyIsLoggedIn = "is_logged_in";
  static const userId = "user_id";

  final SharedPreferences prefs;

  SharedPrefsHelper(this.prefs);

  Future<void> setLoggedIn(bool value, {required String id}) async {
    await prefs.setBool(_keyIsLoggedIn, value);
    await prefs.setString(userId, id);
  }

  bool isLoggedIn() {
    try {
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (error) {
      rethrow;
    } finally {
      // ...
    }
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}

final sharedPrefsProvider = Provider<SharedPrefsHelper>((ref) {
  throw UnimplementedError();
});
