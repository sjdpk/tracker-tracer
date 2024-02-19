import 'package:flutter/material.dart';
import 'package:tracker/src/config/router/app_routes.dart';

reloadBtn(BuildContext context) {
  return Center(
    child: MaterialButton(
      color: Colors.blue,
      onPressed: () {
        context.go(AppRoutesList.homeScreen);
      },
      child: const Text("Reload"),
    ),
  );
}
