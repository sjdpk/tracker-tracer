import 'package:firebase_core/firebase_core.dart';
import 'package:tracker/firebase_options.dart';

import 'firebase.dart';

mixin FirebaseServices {
  static Future<void> init() async {
    /// Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initilize firebase  crashlogger services
    await FirebaseCrashLogger.initialized();

    //  initilize firebase notification services
    await Future.wait<dynamic>([
      FirebaseNotificationService.initialized(),
      FirebaseNotificationService.fcmSubscribe(topic: "tracker")
    ]);
  }
}
