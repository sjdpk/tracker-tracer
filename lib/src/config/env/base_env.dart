import 'package:tracker/src/config/env/application_properties.dart';
import 'tracker_env.dart';
import 'tracer_env.dart';

// @desc :  Abstract base class for all flavor [Tracker, Tracer]
abstract class BaseConfig {
  String get appName;
  String get firebaseNotificationUrl;
  String get firebaseMsgToken;
  String get firebaseDb;
}

/// @desc : Application Development
class Environment {
  Environment._internal();

  factory Environment() {
    return _singleton;
  }

  static final Environment _singleton = Environment._internal();
  static const String trackerApp = 'Tracker';
  static const String tracerApp = 'Tracer';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.tracerApp:
        return TracerConfig();
      case Environment.trackerApp:
        return TrackerConfig();
      default:
        return TracerConfig();
    }
  }
}

//@desc : specify which env shuould run
const String environment = String.fromEnvironment(
  "ENV",
  defaultValue: applicationEnv,
);
