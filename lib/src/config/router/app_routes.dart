// This file defines the routes and screens for navigation in the app,
// including authentication and portal screens and so on.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/main.dart';
import 'package:tracker/src/features/tracer/presentation/screen/tracer_screen.dart';
import 'package:tracker/src/features/tracker/presentation/screen/tracker_screen.dart';
export 'package:go_router/go_router.dart';

class AppRoutesList {
  static const String homeScreen = "/";
  static const String trackerScreen = '/tracker';
  static const String tracerScreen = '/tracer';
}

class AppRoutes {
  static popAndGoTo(BuildContext context, String routeName) {
    Navigator.popUntil(context, (route) => route.settings.name == routeName);
  }

  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutesList.homeScreen,
        redirect: (context, state) async {
          final trackerApp = env.config.appName == "Tracker";
          if (trackerApp) {
            return AppRoutesList.trackerScreen;
          } else {
            return AppRoutesList.tracerScreen;
          }
        },
        builder: (context, state) => TracerScreen(),
      ),
      GoRoute(
        path: AppRoutesList.trackerScreen,
        builder: (context, state) => TrackerScreen(),
      ),
      GoRoute(
        path: AppRoutesList.tracerScreen,
        builder: (context, state) => TracerScreen(),
      ),
    ],
  );
}
