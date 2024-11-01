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
    apiKey: 'AIzaSyBrLimcD3fYntpuus-ySaiH5M11ShlmLj0',
    appId: '1:704923144788:web:f4768dd5d9c9f6b98293c1',
    messagingSenderId: '704923144788',
    projectId: 'transport-93c1d',
    authDomain: 'transport-93c1d.firebaseapp.com',
    storageBucket: 'transport-93c1d.appspot.com',
    measurementId: 'G-GVTWBK0DNY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmLQGZFRWLoKCXyTkq6GnDxWENNLf-HRw',
    appId: '1:704923144788:android:769eff74ea4426e08293c1',
    messagingSenderId: '704923144788',
    projectId: 'transport-93c1d',
    storageBucket: 'transport-93c1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXgSVybicejtRV9WcGqdnLLfr0ElQ6k88',
    appId: '1:704923144788:ios:caedd89ef7b183f58293c1',
    messagingSenderId: '704923144788',
    projectId: 'transport-93c1d',
    storageBucket: 'transport-93c1d.appspot.com',
    iosBundleId: 'com.example.transport',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXgSVybicejtRV9WcGqdnLLfr0ElQ6k88',
    appId: '1:704923144788:ios:caedd89ef7b183f58293c1',
    messagingSenderId: '704923144788',
    projectId: 'transport-93c1d',
    storageBucket: 'transport-93c1d.appspot.com',
    iosBundleId: 'com.example.transport',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBrLimcD3fYntpuus-ySaiH5M11ShlmLj0',
    appId: '1:704923144788:web:ac65db3d445702258293c1',
    messagingSenderId: '704923144788',
    projectId: 'transport-93c1d',
    authDomain: 'transport-93c1d.firebaseapp.com',
    storageBucket: 'transport-93c1d.appspot.com',
    measurementId: 'G-DBR0D1LZML',
  );
}
