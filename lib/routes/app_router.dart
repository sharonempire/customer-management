import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/features/presentation/pages/main_scaffold.dart';
import 'package:management_software/routes/router_consts.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final routeConsts = RouterConsts();
  final prefs = ref.read(sharedPrefsProvider);

  return GoRouter(
    debugLogDiagnostics: true,

    initialLocation:
        prefs.isLoggedIn()
            ? routeConsts.dashboard.route
            : routeConsts.login.route,

    redirect: (context, state) {
      final loggedIn = prefs.isLoggedIn();

      final goingToLogin = state.matchedLocation == routeConsts.login.route;
      final goingToCreatePassword =
          state.matchedLocation == routeConsts.signUp.route;

      if (!loggedIn && !goingToLogin && !goingToCreatePassword) {
        return routeConsts.login.route;
      }

      if (loggedIn && goingToLogin) {
        return routeConsts.dashboard.route;
      }

      return null;
    },

    routes: [
      // Login Route
      GoRoute(
        path: routeConsts.login.route,
        name: routeConsts.login.name,
        builder: routeConsts.login.builder,
      ),

      GoRoute(
        path: routeConsts.signUp.route,
        name: routeConsts.signUp.name,
        builder: routeConsts.signUp.builder,
      ),

      // Shell for main layout
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: routeConsts.dashboard.route,
            name: routeConsts.dashboard.name,
            builder: routeConsts.dashboard.builder,
          ),
          GoRoute(
            path: routeConsts.employeeManagement.route,
            name: routeConsts.employeeManagement.name,
            builder: routeConsts.employeeManagement.builder,
          ),
          GoRoute(
            path: routeConsts.attendance.route,
            name: routeConsts.attendance.name,
            builder: routeConsts.attendance.builder,
            routes: [
              GoRoute(
                path: routeConsts.attendanceHistory.route,
                name: routeConsts.attendanceHistory.name,
                builder: routeConsts.attendanceHistory.builder,
            )]
          ),
          GoRoute(
            path: routeConsts.enquiries.route,
            name: routeConsts.enquiries.name,
            builder: routeConsts.enquiries.builder,
            routes: [
              GoRoute(
                path: routeConsts.leadInfo.route,
                name: routeConsts.leadInfo.name,
                builder: routeConsts.leadInfo.builder,
              ),
            ],
          ),
          GoRoute(
            path: routeConsts.freelancerMangement.route,
            name: routeConsts.freelancerMangement.name,
            builder: routeConsts.freelancerMangement.builder,
          ),
        ],
      ),
    ],
  );
});
