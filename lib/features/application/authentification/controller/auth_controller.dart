import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, UserProfileModel>((ref) {
      final networkService = ref.watch(networkServiceProvider);
      return AuthController(networkService, ref);
    });

class AuthController extends StateNotifier<UserProfileModel> {
  final NetworkService _networkService;
  final Ref ref;

  AuthController(this._networkService, this.ref) : super(UserProfileModel());

  /// LOGIN
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _networkService.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.user != null) {
        log('User logged in: ${response.user!}');
        await SharedPrefsHelper(prefs).setLoggedIn(true, id: response.user!.id);
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Login successful!');
        getUserDetails(context: context);

        context.pushReplacement(RouterConsts().dashboard.route);
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Login failed. Check your credentials.');
      }
    } on AuthException catch (e) {
      ref.read(snackbarServiceProvider).showError(context, e.message);
    } catch (e) {
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Login failed: ${e.toString()}');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _networkService.auth.signUp(
        email: email,
        password: password,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.user != null) {
        await SharedPrefsHelper(prefs).setLoggedIn(true, id: response.user!.id);
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Signup successful!');
        getUserDetails(context: context);
        context.pushReplacement(RouterConsts().dashboard.route);
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Signup failed. Try again.');
      }
    } on AuthException catch (e) {
      ref.read(snackbarServiceProvider).showError(context, e.message);
    } catch (e) {
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Signup failed: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'User ID not found. Please login again.');
        return;
      }

      // 1️⃣ Check if the row exists
      final bool exists = await _networkService.rowExists(
        table: SupabaseTables.profiles,
        id: userId,
      );

      Map<String, dynamic>? response;

      // 2️⃣ If exists → update, otherwise → create (insert)
      if (exists) {
        response = await _networkService.update(
          table: SupabaseTables.profiles,
          id: userId,
          data: updatedData,
        );
        getUserDetails(context: context);
      } else {
        // Ensure the row has correct `id`
        final dataWithId = {'id': userId, ...updatedData};
        response = await _networkService.push(
          table: SupabaseTables.profiles,
          data: dataWithId,
        );
        getUserDetails(context: context);
      }

      // 3️⃣ Show result
      if (response != null) {
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Profile saved successfully!');
        log('Profile save response: $response');
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Failed to save profile.');
      }
    } catch (e) {
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update profile: ${e.toString()}');
      log('Profile update error: $e');
    }
  }

  Future<void> getUserDetails({required BuildContext context}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) {
        context.go(RouterConsts().login.route);
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'User ID not found. Please login again.');
        return;
      }
      final bool exists = await _networkService.rowExists(
        table: SupabaseTables.profiles,
        id: userId,
      );

      Map<String, dynamic>? response;

      if (exists) {
        response = await _networkService.pullById(
          table: SupabaseTables.profiles,
          id: userId,
        );
        storeToSharedPreferences(response!);
      }

      // 3️⃣ Show result
      if (response != null) {
        log('Profile save response: $response');
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Failed to fetch profile.');
      }
    } catch (e) {
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update profile: ${e.toString()}');
      log('Profile update error: $e');
    }
  }

  /// LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      await _networkService.signOut();
      ref
          .read(snackbarServiceProvider)
          .showSuccess(context, 'Logged out successfully!');
      context.go(RouterConsts().login.route);
    } on AuthException catch (e) {
      ref.read(snackbarServiceProvider).showError(context, e.message);
    } catch (e) {
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Logout failed: ${e.toString()}');
    }
  }

  Future<void> storeToSharedPreferences(Map<String, dynamic> data) async {
    SharedPrefsHelper prefsHelper = SharedPrefsHelper(
      await SharedPreferences.getInstance(),
    );
    await prefsHelper.storeUserDetails(data: data);
    state = UserProfileModel.fromMap(data);
  }
}
