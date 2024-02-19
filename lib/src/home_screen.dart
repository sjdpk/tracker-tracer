import 'package:flutter/material.dart';
import 'package:tracker/src/config/router/app_routes.dart';
import 'package:tracker/src/core/resources/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        title: const Text("Tracker-Tracer"),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () => context.push(AppRoutesList.trackerScreen),
              child: const Text("Tracker Screen"),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () => context.push(AppRoutesList.tracerScreen),
              child: const Text("Tracer Screen"),
            )
          ],
        ),
      ),
    );
  }
}
