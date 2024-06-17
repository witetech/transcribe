// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: _getFirebaseOptions());  
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

FirebaseOptions _getFirebaseOptions() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _android;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _ios;
  } else {
    throw UnsupportedError(
      'Firebase is not supported for the platform: $defaultTargetPlatform',
    );
  }
}

FirebaseOptions _android = FirebaseOptions(
  apiKey: dotenv.env['FB_ANDROID_API_KEY']!,
  appId: dotenv.env['FB_ANDROID_APP_ID']!,
  messagingSenderId: dotenv.env['FB_MESSAGING_SENDER_ID']!,
  projectId: dotenv.env['FB_PROJECT_ID']!,
  databaseURL: dotenv.env['FB_DATABASE_URL']!,
  storageBucket: dotenv.env['FB_STORAGE_BUCKET']!,
);

FirebaseOptions _ios = FirebaseOptions(
  apiKey: dotenv.env['FB_IOS_API_KEY']!,
  appId: dotenv.env['FB_IOS_APP_ID']!,
  messagingSenderId: dotenv.env['FB_MESSAGING_SENDER_ID']!,
  projectId: dotenv.env['FB_PROJECT_ID']!,
  databaseURL: dotenv.env['FB_DATABASE_URL']!,
  storageBucket: dotenv.env['FB_STORAGE_BUCKET']!,
  iosBundleId: dotenv.env['FB_IOS_BUNDLE_ID']!,
);
