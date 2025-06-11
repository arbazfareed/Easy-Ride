// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'cubits/navigation_cubit.dart';
import 'cubits/registration/registration_cubit.dart'; // IMPORT RegistrationCubit
import 'navigation/app_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully!');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const EasyRideApp());
}

class EasyRideApp extends StatelessWidget {
  const EasyRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( // Use MultiBlocProvider to provide multiple Cubits
      providers: [
        BlocProvider<NavigationCubit>( // Provide NavigationCubit
          create: (_) => NavigationCubit(),
        ),
        BlocProvider<RegistrationCubit>( // NEW: Provide RegistrationCubit here
          create: (_) => RegistrationCubit(),
        ),
        // Add other global Cubits/Blocs here if needed (e.g., AuthCubit)
      ],
      child: MaterialApp(
        title: 'EasyRide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AppNavigator(), // AppNavigator will now find RegistrationCubit
      ),
    );
  }
}