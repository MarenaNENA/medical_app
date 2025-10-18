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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAq6rj3wnN2cfqaQuBf78vbgOxe7klme5M',
    appId: '1:426729484370:android:cb583850bfadfd543aef8b',
    messagingSenderId: '426729484370',
    projectId: 'medicalapp-d0248',
    storageBucket: 'medicalapp-d0248.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0DN6lMSJtV-JWXMdrIkA9v2HmRUJK65o',
    appId: '1:426729484370:ios:48809b85bbc261463aef8b',
    messagingSenderId: '426729484370',
    projectId: 'medicalapp-d0248',
    storageBucket: 'medicalapp-d0248.firebasestorage.app',
    iosBundleId: 'com.example.flutterMdicalapp1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0DN6lMSJtV-JWXMdrIkA9v2HmRUJK65o',
    appId: '1:426729484370:ios:48809b85bbc261463aef8b',
    messagingSenderId: '426729484370',
    projectId: 'medicalapp-d0248',
    storageBucket: 'medicalapp-d0248.firebasestorage.app',
    iosBundleId: 'com.example.flutterMdicalapp1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5pN9rcO5zqxlg7QjrHFFrLxh39CBwmJk',
    appId: '1:426729484370:web:ca90a7acb5376bf63aef8b',
    messagingSenderId: '426729484370',
    projectId: 'medicalapp-d0248',
    authDomain: 'medicalapp-d0248.firebaseapp.com',
    storageBucket: 'medicalapp-d0248.firebasestorage.app',
    measurementId: 'G-P0MD0BPFXN',
  );
}
