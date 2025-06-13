// // lib/firebase_options.dart
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
//
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     throw UnsupportedError(
//       'DefaultFirebaseOptions are only configured for Web. '
//           'Android/iOS use google-services.json or GoogleService-Info.plist',
//     );
//   }
//
//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: "AIzaSyAehmWgGCKMiNJqrNJMZVOJDfH7hoFwHVY",
//     authDomain: "easyride-cb1f4.firebaseapp.com",
//     projectId: "easyride-cb1f4",
//     storageBucket: "easyride-cb1f4.firebasestorage.app",
//     messagingSenderId: "649869651430",
//     appId: "1:649869651430:web:783495bef1d8eda23a7a27",
//     measurementId: "G-S6ZZCBHEXK",
//   );
// }
