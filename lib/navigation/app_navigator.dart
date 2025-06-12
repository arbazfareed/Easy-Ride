// lib/navigation/app_navigator.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart'; // NEW: Import for page transitions

import '../cubits/navigation_cubit.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/registration/registration_flow.dart';
import '../screens/login_screen.dart';
import '../screens/driver_screen.dart';
import '../screens/customer_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  // Helper method to return the correct widget for the AppPage
  Widget _buildPage(AppPage appPage) {
    debugPrint('AppNavigator: Building screen for $appPage');
    switch (appPage) {
      case AppPage.onboarding:
        return const OnboardingScreen();
      case AppPage.registration:
        return const RegistrationFlowContainer();
      case AppPage.login:
        return const LoginScreen();
      case AppPage.home:
        return const HomeScreen();
      case AppPage.driver:
        return const DriverScreen();
      case AppPage.customer:
        return const CustomerScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // NEW: Handles Android's physical back button
      onWillPop: () async {
        final navCubit = context.read<NavigationCubit>();
        if (navCubit.canPop()) {
          navCubit.pop(); // Pop the custom navigation history
          return false; // Prevent the default system back behavior
        }
        return true; // Allow the app to exit if no more history
      },
      child: BlocBuilder<NavigationCubit, AppPage>(
        builder: (context, appPage) {
          return PageTransitionSwitcher( // NEW: Adds smooth page transitions
            duration: const Duration(milliseconds: 400), // Transition duration
            transitionBuilder: (child, animation, secondaryAnimation) {
              // FadeThroughTransition is good for distinct pages.
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
              // You could also try SharedAxisTransition or FadeScaleTransition
              /*
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal, // Or .vertical, .scaled
                child: child,
              );
              */
            },
            child: _buildPage(appPage), // The page to display
          );
        },
      ),
    );
  }
}