// lib/navigation/app_navigator.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/registration/registration_flow.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart'; // NEW: Import your LoginScreen

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppPage>(
      builder: (context, appPage) { // Changed 'state' to 'appPage' for clarity
        switch (appPage) {
          case AppPage.onboarding:
            return const OnboardingScreen();
          case AppPage.registration:
            return const RegistrationFlowContainer();
          case AppPage.login: // NEW CASE: Handle AppPage.login
            return const LoginScreen();
          case AppPage.home:
            return const HomeScreen();
        }
      },
    );
  }
}