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
    apiKey: 'AIzaSyBRqi7MyU-fNek6U84DHHXLYK7IUk_3p1Y',
    appId: '1:282023228454:web:03f8348f81adce3835e2e7',
    messagingSenderId: '282023228454',
    projectId: 'ulisse500',
    authDomain: 'ulisse500.firebaseapp.com',
    storageBucket: 'ulisse500.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwwiP1hmuu_g71oRGyvff8q7Z7z9tzOF4',
    appId: '1:282023228454:android:1efc4f9dc93767f835e2e7',
    messagingSenderId: '282023228454',
    projectId: 'ulisse500',
    storageBucket: 'ulisse500.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArk_XoN0DgwTJIBTbgLrjfJ2qIRhAV-vE',
    appId: '1:282023228454:ios:8aeef3f9974b683f35e2e7',
    messagingSenderId: '282023228454',
    projectId: 'ulisse500',
    storageBucket: 'ulisse500.appspot.com',
    iosBundleId: 'com.example.ulisse500',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArk_XoN0DgwTJIBTbgLrjfJ2qIRhAV-vE',
    appId: '1:282023228454:ios:8aeef3f9974b683f35e2e7',
    messagingSenderId: '282023228454',
    projectId: 'ulisse500',
    storageBucket: 'ulisse500.appspot.com',
    iosBundleId: 'com.example.ulisse500',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRqi7MyU-fNek6U84DHHXLYK7IUk_3p1Y',
    appId: '1:282023228454:web:41b0b896174ab63735e2e7',
    messagingSenderId: '282023228454',
    projectId: 'ulisse500',
    authDomain: 'ulisse500.firebaseapp.com',
    storageBucket: 'ulisse500.appspot.com',
  );

}