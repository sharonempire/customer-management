import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final NetworkService _networkService;
  AuthRepository(this._networkService);

  /// SIGN IN
  Future<AuthResponse?> signIn(String email, String password) async {
    return await _networkService.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// SIGN UP
  Future<AuthResponse?> signUp(String email, String password) async {
    return await _networkService.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Check if email exists in profiles
  Future<bool> emailExists(String email) async {
    return await _networkService.emailExists(
      table: SupabaseTables.profiles,
      email: email,
    );
  }

  /// Update profile by user ID
  Future<Map<String, dynamic>?> updateProfileById(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await _networkService.update(
      table: SupabaseTables.profiles,
      id: userId,
      data: data,
    );
  }

  /// Update profile by email
  Future<Map<String, dynamic>?> updateProfileByEmail(
    String email,
    Map<String, dynamic> data,
  ) async {
    return await _networkService.updateWithEmail(
      table: SupabaseTables.profiles,
      email: email,
      data: data,
    );
  }

  /// Insert a new profile row
  Future<Map<String, dynamic>?> addProfile(Map<String, dynamic> data) async {
    return await _networkService.push(
      table: SupabaseTables.profiles,
      data: data,
    );
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    return await _networkService.pullById(
      table: SupabaseTables.profiles,
      id: userId,
    );
  }

  /// Check if user profile row exists
  Future<bool> rowExists(String userId) async {
    return await _networkService.rowExists(
      table: SupabaseTables.profiles,
      id: userId,
    );
  }

  /// Save user data in SharedPreferences
  Future<void> storeUserData(Map<String, dynamic> data) async {
    SharedPrefsHelper prefsHelper = SharedPrefsHelper(
      await SharedPreferences.getInstance(),
    );
    await prefsHelper.storeUserDetails(data: data);
  }

  /// Save login state
  Future<void> saveLoginState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await SharedPrefsHelper(prefs).setLoggedIn(true, id: userId);
  }

  /// Sign out user
  Future<void> signOut() async {
    return await _networkService.signOut();
  }
}
