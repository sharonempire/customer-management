import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/presentation/pages/attendance/attendance.dart';
import 'package:management_software/features/presentation/pages/auth/signup.dart';
import 'package:management_software/features/presentation/pages/auth/login_page.dart';
import 'package:management_software/features/presentation/pages/employee_mangement/employee_management.dart';
import 'package:management_software/features/presentation/pages/dashboard/dashboard.dart';
import 'package:management_software/features/presentation/pages/lead_management/lead_management.dart';
import 'package:management_software/features/presentation/pages/freelancer_mangement/freelancer_mangement.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';

class RouterConsts {
  final RouteModel login = RouteModel('/login', 'Login', (context, state) {
    return const LoginPage();
  });

  final RouteModel signUp = RouteModel('/signup', 'Sign up', (context, state) {
    return const SignUpPage();
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

  final RouteModel enquiries = RouteModel(
    '/lead-management',
    'Lead Management',
    (context, state) {
      return const LeadManagement();
    },
  );

  final RouteModel employeeManagement = RouteModel(
    '/employee-management',
    'Employee Management',
    (context, state) {
      return const EmployeeManagement();
    },
  );

  final RouteModel leadInfo = RouteModel('lead-info', 'Lead Info', (
    context,
    state,
  ) {
    return const LeadInfoPopup();
  });
}

class RouteModel {
  String route;
  String name;
  Widget Function(BuildContext, GoRouterState)? builder;
  RouteModel(this.route, this.name, this.builder);
}
