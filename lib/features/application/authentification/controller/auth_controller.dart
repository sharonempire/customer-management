import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  final networkService = ref.watch(networkServiceProvider);
  return AuthController(networkService, ref);
});

class AuthController extends StateNotifier<bool> {
  final NetworkService _networkService;
  final Ref ref;

  AuthController(this._networkService, this.ref)
    : super(_networkService.isAuthenticated);

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
        state = true;
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Login successful!');
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
        state = true;
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Signup successful!');
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

  /// LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      await _networkService.signOut();
      state = false;
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

  /// CHECK AUTH STATE (optional, can be used on app startup)
  void checkAuth() {
    state = _networkService.isAuthenticated;
  }
}
