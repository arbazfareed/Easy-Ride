import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/navigation_cubit.dart';
import 'cubits/registration/registration_cubit.dart';
import 'navigation/app_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');

  if (kIsWeb) {
    const FirebaseOptions options = FirebaseOptions(
      apiKey: "AIzaSyAehmWgGCKMiNJqrNJMZVOJDfH7hoFwHVY",
      authDomain: "easyride-cb1f4.firebaseapp.com",
      projectId: "easyride-cb1f4",
      storageBucket: "easyride-cb1f4.appspot.com",
      messagingSenderId: "649869651430",
      appId: "1:649869651430:web:783495bef1d8eda23a7a27",
      measurementId: "G-S6ZZCBHEXK",
    );
    await Firebase.initializeApp(options: options);
  } else {
    await Firebase.initializeApp(); // Android/iOS uses google-services.json / plist
  }

  print('Firebase initialized successfully!');

  runApp(const EasyRideApp());
}

class EasyRideApp extends StatelessWidget {
  const EasyRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<RegistrationCubit>(create: (_) => RegistrationCubit()),
      ],
      child: MaterialApp(
        title: 'EasyRide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AppNavigator(),
      ),
    );
  }
}
