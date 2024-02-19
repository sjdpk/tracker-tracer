import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/src/config/themes/app_theme.dart';
import 'package:tracker/src/core/services/firebase/firebase.dart';
import 'locator.dart' as di;
import 'src/config/router/app_routes.dart';
import 'src/features/tracker/presentation/bloc/tracker/tracker_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await di.init();
  await FirebaseServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrackerBloc>(create: (_) => di.sl<TrackerBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.routes,
        title: 'Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appDefaultTheme(),
      ),
    );
  }
}
