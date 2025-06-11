// lib/screens/registration/registration_flow_container.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/cubits/navigation_cubit.dart'; // Still needed for other navigation logic if any, but not directly for 'completed'
import 'package:easyride/screens/registration/name_screen.dart';
import 'package:easyride/screens/registration/phone_screen.dart';
// CORRECTED IMPORT: Changed from email_screen.dart
import 'package:easyride/screens/login_screen.dart';

import 'email_screen.dart'; // NEW IMPORT: Required to navigate to LoginScreen

class RegistrationFlowContainer extends StatelessWidget {
  const RegistrationFlowContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        // This listener ensures that once registration is 'completed'
        // the app navigates to the desired screen.
        if (state.currentStep == RegistrationStep.completed && state.errorMessage == null) {
          // The snackbar with "Registration successful!" is already shown by EmailPasswordScreen's listener.
          // Here, we handle the final navigation.

          // Changed: Navigate to LoginScreen instead of Home after successful registration.
          // This allows the user to log in with their newly created (and verified) account.
          Future.delayed(const Duration(seconds: 3), () { // Keep delay to allow snackbar to be seen
            // Using pushReplacement to clear the registration flow from the navigation stack
            // and replace it with the LoginScreen.
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );

            // Optional: Consider resetting the registration cubit state here
            // to clear data from previous registration attempt if needed for next time.
            // context.read<RegistrationCubit>().resetState(); // You'd need to add a resetState method to your cubit
          });
        }
      },
      builder: (context, state) {
        // We use AnimatedSwitcher to provide a subtle cross-fade transition
        // between the different registration screens. The `key` on each screen
        // is crucial for AnimatedSwitcher to identify different widgets.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Duration of the transition
          child: _getCurrentRegistrationScreen(state.currentStep), // Use state.currentStep
        );
      },
    );
  }

  // Helper method to return the correct screen widget based on the current step
  Widget _getCurrentRegistrationScreen(RegistrationStep step) {
    switch (step) {
      case RegistrationStep.name:
        return const NameScreen(key: ValueKey('nameScreen')); // Assign a unique key
      case RegistrationStep.phone:
        return const PhoneScreen(key: ValueKey('phoneScreen')); // Assign a unique key
      case RegistrationStep.emailPassword:
        return const EmailPasswordScreen(key: ValueKey('emailPasswordScreen')); // Correctly references EmailPasswordScreen
      case RegistrationStep.completed:
      // When the state is 'completed', the listener handles the navigation away.
      // As a fallback, you could show a temporary loading screen or a success message
      // here just before the navigation takes effect.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Or a brief "Success!" message
          ),
        );
    }
  }
}