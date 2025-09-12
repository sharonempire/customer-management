import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/data/authentification/repositories/auth_repositories.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, UserProfileModel>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  final repository = AuthRepository(networkService);
  return AuthController(repository, ref);
});

class AuthController extends StateNotifier<UserProfileModel> {
  final AuthRepository _repo;
  final Ref ref;

  AuthController(this._repo, this.ref) : super(UserProfileModel());

  /// LOGIN
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _repo.signIn(email, password);
      if (response?.user != null) {
        await _repo.saveLoginState(response!.user!.id);
        ref.read(snackbarServiceProvider).showSuccess(context, 'Login successful!');
        await getUserDetails(context: context);
        context.pushReplacement(RouterConsts().dashboard.route);
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Login failed. Check credentials.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Login failed: $e');
    }
  }

  /// SIGNUP
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final exists = await _repo.emailExists(email);
      if (!exists) {
        ref.read(snackbarServiceProvider).showError(context, 'Email does not exist.');
        return;
      }

      final response = await _repo.signUp(email, password);
      if (response?.user != null) {
        await _repo.saveLoginState(response!.user!.id);
        ref.read(snackbarServiceProvider).showSuccess(context, 'Signup successful!');
        await updateUserUuid(context: context, email: email, userId: response.user!.id);
        context.pushReplacement(RouterConsts().dashboard.route);
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Signup failed. Try again.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Signup failed: $e');
    }
  }

  /// UPDATE USER PROFILE (Insert if not exists)
  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) {
        ref.read(snackbarServiceProvider).showError(context, 'User ID not found. Please login again.');
        return;
      }

      final exists = await _repo.rowExists(userId);
      Map<String, dynamic>? response;

      if (exists) {
        if (mapEquals(updatedData, state.toJson())) {
          return; // No changes
        }
        response = await _repo.updateProfileById(userId, updatedData);
      } else {
        final dataWithId = {'id': userId, ...updatedData};
        response = await _repo.addProfile(dataWithId);
      }

      if (response != null) {
        await getUserDetails(context: context);
        ref.read(snackbarServiceProvider).showSuccess(context, 'Profile saved successfully!');
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to save profile.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Failed to update profile: $e');
    }
  }

  /// UPDATE USER UUID AFTER SIGNUP
  Future<void> updateUserUuid({
    required BuildContext context,
    required String email,
    required String userId,
  }) async {
    try {
      final response = await _repo.updateProfileByEmail(email, {'id': userId});
      await getUserDetails(context: context);
      if (response != null) {
        ref.read(snackbarServiceProvider).showSuccess(context, 'Profile saved successfully!');
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to save profile.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Failed to update profile: $e');
    }
  }

  /// ADD EMPLOYEE
  Future<void> addEmployee({
    required BuildContext context,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final exists = await _repo.emailExists(updatedData['email']);
      if (exists) {
        ref.read(snackbarServiceProvider).showError(context, 'Email already exists.');
        return;
      }
      final response = await _repo.addProfile(updatedData);
      if (response != null) {
        ref.read(snackbarServiceProvider).showSuccess(context, 'Employee added successfully!');
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to add employee.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Failed to add employee: $e');
    }
  }

  /// GET USER DETAILS
  Future<void> getUserDetails({required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);
      if (userId == null || userId.isEmpty) {
        context.go(RouterConsts().login.route);
        ref.read(snackbarServiceProvider).showError(context, 'User ID not found. Please login again.');
        return;
      }

      final exists = await _repo.rowExists(userId);
      if (!exists) return;

      final response = await _repo.getUserById(userId);
      if (response != null) {
        await _repo.storeUserData(response);
        state = UserProfileModel.fromMap(response);
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to fetch profile.');
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Failed to fetch profile: $e');
    }
  }

  /// LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      await _repo.signOut();
      ref.read(snackbarServiceProvider).showSuccess(context, 'Logged out successfully!');
      context.go(RouterConsts().login.route);
    } catch (e) {
      ref.read(snackbarServiceProvider).showError(context, 'Logout failed: $e');
    }
  }

  /// GENERATE UNIQUE UUID
  String generateUniqueId() {
    return Uuid().v4();
  }
}
