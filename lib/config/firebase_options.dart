// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCwoCVeUNXo952prMwNh6ABvtm2uDyPfJY',
    appId: '1:707613648843:web:634eb9d66eb75689ecb84e',
    messagingSenderId: '707613648843',
    projectId: 'socialtutorial-82452',
    authDomain: 'socialtutorial-82452.firebaseapp.com',
    storageBucket: 'socialtutorial-82452.appspot.com',
    measurementId: 'G-SXPN3XWLDD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXQY2Sk8X-cNZdawRLL_hUf7HTQ4p6N6U',
    appId: '1:707613648843:android:4953bf056a26b8f3ecb84e',
    messagingSenderId: '707613648843',
    projectId: 'socialtutorial-82452',
    storageBucket: 'socialtutorial-82452.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDE5gart3i8X8aJYyQc7g9jxzY3Nq3Ih1c',
    appId: '1:707613648843:ios:84f3a7fbef3d00b6ecb84e',
    messagingSenderId: '707613648843',
    projectId: 'socialtutorial-82452',
    storageBucket: 'socialtutorial-82452.appspot.com',
    iosBundleId: 'com.example.socialMedia',
  );
}