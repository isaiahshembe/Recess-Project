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
    apiKey: 'AIzaSyCE_AOvHiW18jKuzp1UzjqbZJCs6sJlvIc',
    appId: '1:804252301690:web:5391d086c395c018a3fec3',
    messagingSenderId: '804252301690',
    projectId: 'touristapp-c4712',
    authDomain: 'touristapp-c4712.firebaseapp.com',
    storageBucket: 'touristapp-c4712.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0iqw78yhyWYs5HSi8ItFpCE-IpKtxdYg',
    appId: '1:804252301690:android:a0125e619e45bc1ba3fec3',
    messagingSenderId: '804252301690',
    projectId: 'touristapp-c4712',
    storageBucket: 'touristapp-c4712.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSLLC1CH2RSoAVpZGaG5i6L2AtkLERVUk',
    appId: '1:804252301690:ios:cd4916565cc00461a3fec3',
    messagingSenderId: '804252301690',
    projectId: 'touristapp-c4712',
    storageBucket: 'touristapp-c4712.appspot.com',
    iosBundleId: 'com.example.touristapp',
  );
}
