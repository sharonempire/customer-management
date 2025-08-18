import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/presentation/pages/main_scaffold.dart';
import 'package:management_software/routes/router_consts.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final routeConsts = RouterConsts();

  return GoRouter(
    initialLocation: routeConsts.dashboard.route,
    debugLogDiagnostics: true,

    redirect: (context, state) async {
      return null;
    },

    routes: [
      GoRoute(
        path: routeConsts.login.route,
        name: routeConsts.login.name,
        builder: routeConsts.login.builder,
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: routeConsts.dashboard.route,
            name: routeConsts.dashboard.name,
            builder: routeConsts.dashboard.builder,
          ),
          GoRoute(
            path: routeConsts.attendance.route,
            name: routeConsts.attendance.name,
            builder: routeConsts.attendance.builder,
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
