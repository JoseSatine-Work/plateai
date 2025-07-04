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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAtaDFjs_dtjFLVGFyyX3hmOwyFX2iJYgI',
    appId: '1:2688408584:web:15e0e2b90e94d2b692c5bd',
    messagingSenderId: '2688408584',
    projectId: 'plate-61095',
    authDomain: 'plate-61095.firebaseapp.com',
    storageBucket: 'plate-61095.firebasestorage.app',
    measurementId: 'G-W0WL08S7BK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhqkSV5lRh95kSq7l0slZwFPhh8NKrHY8',
    appId: '1:2688408584:android:d525e11ffc9d9f7092c5bd',
    messagingSenderId: '2688408584',
    projectId: 'plate-61095',
    storageBucket: 'plate-61095.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmhezImeTfOQ8zpsDVDHxNiqb3YaiemlE',
    appId: '1:2688408584:ios:a25cd619b1ac961892c5bd',
    messagingSenderId: '2688408584',
    projectId: 'plate-61095',
    storageBucket: 'plate-61095.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmhezImeTfOQ8zpsDVDHxNiqb3YaiemlE',
    appId: '1:2688408584:ios:a25cd619b1ac961892c5bd',
    messagingSenderId: '2688408584',
    projectId: 'plate-61095',
    storageBucket: 'plate-61095.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtaDFjs_dtjFLVGFyyX3hmOwyFX2iJYgI',
    appId: '1:2688408584:web:dacd57a4332e9fa392c5bd',
    messagingSenderId: '2688408584',
    projectId: 'plate-61095',
    authDomain: 'plate-61095.firebaseapp.com',
    storageBucket: 'plate-61095.firebasestorage.app',
    measurementId: 'G-SP6M214L7G',
  );
}
