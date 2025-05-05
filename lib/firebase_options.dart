import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDmpWgc6FhWjhvIQ9oSnPKNbMUjVJvwiuY",
    authDomain: "crossplatformassignment-4a91c.firebaseapp.com",
    projectId: "crossplatformassignment-4a91c",
    storageBucket: "crossplatformassignment-4a91c.firebasestorage.app",
    messagingSenderId: "676474124403",
    appId: "1:676474124403:web:fe76eb491f2916e0899206",
    measurementId: "G-KMW6QP5CD2",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBWMBHv2HVyub28J8MeB3XbWynyZ5lMzpk",
    appId: "1:676474124403:android:523e7cc5e7063986899206",
    messagingSenderId: "676474124403",
    projectId: "crossplatformassignment-4a91c",
    storageBucket: "crossplatformassignment-4a91c.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBWMBHv2HVyub28J8MeB3XbWynyZ5lMzpk",
    appId: "1:676474124403:ios:replace_this_with_ios_app_id",
    messagingSenderId: "676474124403",
    projectId: "crossplatformassignment-4a91c",
    storageBucket: "crossplatformassignment-4a91c.appspot.com",
    iosBundleId: "com.company.IOSappCrossplatform",
  );
}
