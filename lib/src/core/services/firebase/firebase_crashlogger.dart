import 'dart:isolate';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashLogger {
  static Future<void> initialized() async {
    // Pass all uncaught errors from the framework to Crashlytics.
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Async exceptions
    PlatformDispatcher.instance.onError = ((exception, stackTrace) {
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
      return true;
    });

    // Async exceptions
    PlatformDispatcher.instance.onError = ((exception, stackTrace) {
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
      return true;
    });

    /// Catch errors that happen outside of the Flutter context,
    Isolate.current.addErrorListener(
      RawReceivePort((List<dynamic> pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last as StackTrace,
        );
      }).sendPort,
    );
  }

  static Future<void> nonFatalError({required dynamic error, StackTrace? stackTrace}) async {
    await FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: 'a non-fatal error');
  }

  static Future<void> fatalError({required dynamic error, StackTrace? stackTrace}) async {
    await FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: 'a fatal error', fatal: true);
  }
}
