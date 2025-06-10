// lib/screens/registration/registration_flow_container.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/cubits/navigation_cubit.dart'; // To navigate to home when registration is done
import 'package:easyride/screens/registration/name_screen.dart';
import 'package:easyride/screens/registration/phone_screen.dart';
import 'email_screen.dart'; // CORRECTED IMPORT: Use the new name

class RegistrationFlowContainer extends StatelessWidget { // Keep this name for consistency
  const RegistrationFlowContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        // This listener ensures that once registration is 'completed'
        // the app navigates to the home screen (or wherever your main app starts).
        if (state.currentStep == RegistrationStep.completed) {
          // You could also show a success message here before navigating.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Welcome to EasyRide.'),
              backgroundColor: Colors.green, // A success color
            ),
          );
          // Navigate to the home page using your global NavigationCubit
          context.read<NavigationCubit>().navigateToHome();
        }
      },
      builder: (context, state) {
        // We use AnimatedSwitcher to provide a subtle cross-fade transition
        // between the different registration screens. The `key` on each screen
        // is crucial for AnimatedSwitcher to identify different widgets.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Duration of the transition
          child: _getCurrentRegistrationScreen(state.currentStep), // CORRECTED: Use state.currentStep
        );
      },
    );
  }

  // Helper method to return the correct screen widget based on the current step
  Widget _getCurrentRegistrationScreen(RegistrationStep step) {
    switch (step) { // CORRECTED: Switch on the RegistrationStep enum
      case RegistrationStep.name:
        return const NameScreen(key: ValueKey('nameScreen')); // Assign a unique key
      case RegistrationStep.phone:
        return const PhoneScreen(key: ValueKey('phoneScreen')); // Assign a unique key
      case RegistrationStep.emailPassword: // CORRECTED: Use the new enum value for Email/Password screen
        return const EmailPasswordScreen(key: ValueKey('emailPasswordScreen')); // CORRECTED: Use the new screen widget
      case RegistrationStep.completed:
      // If the state is 'completed', this case should ideally not be reached
      // because the listener should trigger navigation.
      // As a fallback, you could show a temporary loading screen or a success message.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Or a success animation/message
          ),
        );
    }
  }
}