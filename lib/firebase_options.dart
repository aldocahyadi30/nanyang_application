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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbFO24WxX73awiHqanLeROmUv9ZiC_gpw',
    appId: '1:841268275695:android:a847ed4d1c1f34104bae1a',
    messagingSenderId: '841268275695',
    projectId: 'nanyang-mobile',
    storageBucket: 'nanyang-mobile.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAavJZrid1sgBIZo4m-z4FOV2xLruoeVRg',
    appId: '1:841268275695:ios:9deda8c2bfc18d0d4bae1a',
    messagingSenderId: '841268275695',
    projectId: 'nanyang-mobile',
    storageBucket: 'nanyang-mobile.appspot.com',
    iosBundleId: 'com.example.nanyangApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAponaeS6aQ_-tdqktXvxR3kir-Hz-jWyY',
    appId: '1:841268275695:web:71fd9d6bcfaef2b84bae1a',
    messagingSenderId: '841268275695',
    projectId: 'nanyang-mobile',
    authDomain: 'nanyang-mobile.firebaseapp.com',
    storageBucket: 'nanyang-mobile.appspot.com',
    measurementId: 'G-22C2YMZQ6D',
  );

}