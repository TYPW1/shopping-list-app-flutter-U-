// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBoyvTeOqWqJJdLJQNl9_x1_-2OWj1-3s4',
    appId: '1:129961127943:web:5a988ff29242f381fabaa2',
    messagingSenderId: '129961127943',
    projectId: 'typw-shopping-list-app',
    authDomain: 'typw-shopping-list-app.firebaseapp.com',
    storageBucket: 'typw-shopping-list-app.appspot.com',
    measurementId: 'G-0ZBK72G1RM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDO8ZO70GQHJMUfH2q0w7AOdc6x_BNJb9I',
    appId: '1:129961127943:android:4d43ca850102572afabaa2',
    messagingSenderId: '129961127943',
    projectId: 'typw-shopping-list-app',
    storageBucket: 'typw-shopping-list-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDURQy5s83R2_sPKlMMa6Gs0OLmC3uLhtU',
    appId: '1:129961127943:ios:9e605529b9564ccbfabaa2',
    messagingSenderId: '129961127943',
    projectId: 'typw-shopping-list-app',
    storageBucket: 'typw-shopping-list-app.appspot.com',
    iosClientId: '129961127943-p45hlkh6ubhhpseq8thp11qhqfatn6f7.apps.googleusercontent.com',
    iosBundleId: 'com.example.newApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDURQy5s83R2_sPKlMMa6Gs0OLmC3uLhtU',
    appId: '1:129961127943:ios:9e605529b9564ccbfabaa2',
    messagingSenderId: '129961127943',
    projectId: 'typw-shopping-list-app',
    storageBucket: 'typw-shopping-list-app.appspot.com',
    iosClientId: '129961127943-p45hlkh6ubhhpseq8thp11qhqfatn6f7.apps.googleusercontent.com',
    iosBundleId: 'com.example.newApp',
  );
}
