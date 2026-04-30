
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBe8byfY9E34pg1BK7kGsOuctGju4DPAUo',
    appId: '1:1074171465276:ios:717fb563405df97bab3d39',
    messagingSenderId: '1074171465276',
    projectId: 'voice-profile-a64b7',
    storageBucket: 'voice-profile-a64b7.firebasestorage.app',
    iosClientId: '1074171465276-i7890lscvu2cqk32o8ecmhtbo1dp5og0.apps.googleusercontent.com',
    iosBundleId: 'com.example.profileBuilder',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAPKtv9uNz8Je-RgMO-pgtL7dNpKHDxMIY',
    appId: '1:1074171465276:web:535450b73348c3bfab3d39',
    messagingSenderId: '1074171465276',
    projectId: 'voice-profile-a64b7',
    authDomain: 'voice-profile-a64b7.firebaseapp.com',
    storageBucket: 'voice-profile-a64b7.firebasestorage.app',
    measurementId: 'G-J53CB9WSD7',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBe8byfY9E34pg1BK7kGsOuctGju4DPAUo',
    appId: '1:1074171465276:ios:717fb563405df97bab3d39',
    messagingSenderId: '1074171465276',
    projectId: 'voice-profile-a64b7',
    storageBucket: 'voice-profile-a64b7.firebasestorage.app',
    iosClientId: '1074171465276-i7890lscvu2cqk32o8ecmhtbo1dp5og0.apps.googleusercontent.com',
    iosBundleId: 'com.example.profileBuilder',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8vOPlnH50dSHx3HGf-odBMAYe16iPP9E',
    appId: '1:1074171465276:android:b33a57e54f530debab3d39',
    messagingSenderId: '1074171465276',
    projectId: 'voice-profile-a64b7',
    storageBucket: 'voice-profile-a64b7.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAPKtv9uNz8Je-RgMO-pgtL7dNpKHDxMIY',
    appId: '1:1074171465276:web:063d9fefffe51953ab3d39',
    messagingSenderId: '1074171465276',
    projectId: 'voice-profile-a64b7',
    authDomain: 'voice-profile-a64b7.firebaseapp.com',
    storageBucket: 'voice-profile-a64b7.firebasestorage.app',
    measurementId: 'G-RWPEH46Y23',
  );

}