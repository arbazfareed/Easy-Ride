// lib/cubits/navigation_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum to define all the app-level pages for navigation
enum AppPage {
  onboarding,
  registration, // This will now start the registration flow
  login,        // NEW: For direct navigation to the login screen
  home,
}

/// Cubit to handle navigation between app-level pages
class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.onboarding); // App starts on onboarding

  /// Navigate to the Registration flow (NameScreen)
  void navigateToRegistration() => emit(AppPage.registration);

  /// Navigate to the Login screen
  void navigateToLogin() => emit(AppPage.login); // NEW METHOD

  /// Navigate to the Home screen (after registration, or login)
  void navigateToHome() => emit(AppPage.home);

  /// Navigate to the Onboarding screen (e.g., if needed for reset)
  void navigateToOnboarding() => emit(AppPage.onboarding);
}
