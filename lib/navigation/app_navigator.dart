// lib/navigation/app_navigator.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../cubits/registration/registration_cubit.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/registration/registration_flow.dart';

import '../screens/home_screen.dart'; // Assuming you have this screen for 'home'

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppPage>(
      builder: (context, state) {
        switch (state) {
          case AppPage.onboarding:
            return const OnboardingScreen();
          case AppPage.registration:
            // Provide RegistrationCubit here, as it's the entry point to that flow
            return BlocProvider(
              create: (_) => RegistrationCubit(),
              child: const RegistrationFlowContainer(),
            );
          case AppPage.home: // Now handling the 'home' state
            // In a real app, this would be your main Home Screen
            return const HomeScreen(); // Assuming you have a HomeScreen defined
            // For now, if you don't have HomeScreen, you can use a placeholder:
            // return const Scaffold(
            //   body: Center(
            //     child: Text(
            //       "Welcome Home!",
            //       style: TextStyle(fontSize: 24, color: Colors.green),
            //     ),
            //   ),
            // );
        }
      },
    );
  }
}
