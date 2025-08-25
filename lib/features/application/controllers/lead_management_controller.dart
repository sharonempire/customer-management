import 'package:flutter_riverpod/flutter_riverpod.dart';

final leadManagementControllerProvider =
    StateNotifierProvider<LeadManagementController, bool>((ref) {
      return LeadManagementController(false);
    });

class LeadManagementController extends StateNotifier<bool> {
  LeadManagementController(super.state);
}