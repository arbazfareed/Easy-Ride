// lib/cubits/navigation_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum to define all the app-level pages for navigation
enum AppPage {
  onboarding,
  registration,
  home, // Re-introduced for post-registration navigation
}

/// Cubit to handle navigation between app-level pages
class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.onboarding); // App starts on onboarding

  /// Navigate to the Registration screen
  void navigateToRegistration() => emit(AppPage.registration);

  /// Navigate to the Home screen (after registration, or login)
  void navigateToHome() => emit(AppPage.home); // Re-introduced

  /// Navigate to the Onboarding screen (e.g., if needed for reset)
  void navigateToOnboarding() => emit(AppPage.onboarding);
}
