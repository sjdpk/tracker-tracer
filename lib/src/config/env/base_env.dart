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

  static const String tracker = 'Tracker';
  static const String tracer = 'Tracer';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.tracer:
        return TracerConfig();
      case Environment.tracker:
        return TrackerConfig();
      default:
        return TrackerConfig();
    }
  }
}

//@desc : specify which env shuould run
const String environment = String.fromEnvironment(
  "ENV",
  defaultValue: applicationEnv,
);
