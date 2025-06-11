// lib/navigation/app_navigator.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/registration/registration_flow.dart';
import '../screens/login_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppPage>(
      builder: (context, appPage) {
        switch (appPage) {
          case AppPage.onboarding:
            return const OnboardingScreen();
          case AppPage.registration:
            return const RegistrationFlowContainer();
          case AppPage.login:
            return const LoginScreen();
          case AppPage.home:
            return const HomeScreen(); // This is the target screen
        }
      },
    );
  }
}
