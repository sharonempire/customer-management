import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/presentation/pages/attendance/attendance.dart';
import 'package:management_software/features/presentation/pages/auth/login_page.dart';
import 'package:management_software/features/presentation/pages/dashboard/dashboard.dart';
import 'package:management_software/features/presentation/pages/enquiries/enquiries.dart';
import 'package:management_software/features/presentation/pages/freelancer_mangement/freelancer_mangement.dart';

class RouterConsts {
  final RouteModel login = RouteModel('/login', 'Login', (context, state) {
    return Material(child: const LoginPage());
  });

  final RouteModel attendance = RouteModel('/attendance', 'Attendance', (
    context,
    state,
  ) {
    return const AttendanceScreen();
  });

  final RouteModel freelancerMangement = RouteModel(
    '/freelancer-management',
    'Freelancer Mangement',
    (context, state) {
      return const FreelancerMangement();
    },
  );

  final RouteModel dashboard = RouteModel('/dashboard', 'Dashboard', (
    context,
    state,
  ) {
    return const Dashboard();
  });

  final RouteModel enquiries = RouteModel('/enquiries', 'Enquiries', (
    context,
    state,
  ) {
    return const Enquiries();
  });
}

class RouteModel {
  String route;
  String name;
  Widget Function(BuildContext, GoRouterState)? builder;
  RouteModel(this.route, this.name, this.builder);
}
