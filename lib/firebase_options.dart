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
    apiKey: 'AIzaSyCFbhi_DGpDC6hxSGvuJAXnhNk5l-fyaQY',
    appId: '1:481430634597:web:d287c867baaef767bec68c',
    messagingSenderId: '481430634597',
    projectId: 'geolocation-876e5',
    authDomain: 'geolocation-876e5.firebaseapp.com',
    storageBucket: 'geolocation-876e5.firebasestorage.app',
    measurementId: 'G-RTY0LLEVYS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEWMHG2qPEsBfrG4l-EfWEJLuaWTfwWlI',
    appId: '1:481430634597:android:5d550e37ba9ae0cdbec68c',
    messagingSenderId: '481430634597',
    projectId: 'geolocation-876e5',
    storageBucket: 'geolocation-876e5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhVwcuHANCl_uVRvdUgWQOhY-GVLrmPtw',
    appId: '1:481430634597:ios:fdd28e5cfa738acdbec68c',
    messagingSenderId: '481430634597',
    projectId: 'geolocation-876e5',
    storageBucket: 'geolocation-876e5.firebasestorage.app',
    iosBundleId: 'com.example.newApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhVwcuHANCl_uVRvdUgWQOhY-GVLrmPtw',
    appId: '1:481430634597:ios:fdd28e5cfa738acdbec68c',
    messagingSenderId: '481430634597',
    projectId: 'geolocation-876e5',
    storageBucket: 'geolocation-876e5.firebasestorage.app',
    iosBundleId: 'com.example.newApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFbhi_DGpDC6hxSGvuJAXnhNk5l-fyaQY',
    appId: '1:481430634597:web:0b5b4a842e4204e9bec68c',
    messagingSenderId: '481430634597',
    projectId: 'geolocation-876e5',
    authDomain: 'geolocation-876e5.firebaseapp.com',
    storageBucket: 'geolocation-876e5.firebasestorage.app',
    measurementId: 'G-GNWYH0CPGQ',
  );
}
