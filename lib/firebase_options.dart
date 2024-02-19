// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfTO897EsZguIYG4hoQN-fbgCELF2Z_Tk',
    appId: '1:348073515210:android:4b31b459998b2b1c347c33',
    messagingSenderId: '348073515210',
    projectId: 'tracker-tracer',
    databaseURL: 'https://tracker-tracer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tracker-tracer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgTQmWQ2OCkt9975Iy6PXi6lrp1Pf4Lxs',
    appId: '1:348073515210:ios:684b41415335f3c8347c33',
    messagingSenderId: '348073515210',
    projectId: 'tracker-tracer',
    databaseURL: 'https://tracker-tracer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tracker-tracer.appspot.com',
    iosBundleId: 'np.com.sapkotadeepak.tracker',
  );
}
