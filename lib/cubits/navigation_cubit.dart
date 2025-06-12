// lib/cubits/navigation_cubit.dart

import 'package:flutter/material.dart'; // Needed for debugPrint (and potentially others like Navigator for alternative method)
import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum to define all the app-level pages for navigation
enum AppPage {
  onboarding,
  registration, // This will now start the registration flow
  login,        // For direct navigation to the login screen
  home,
  driver,       // Page for the Driver dashboard
  customer,     // Page for the Customer dashboard
}

/// Cubit to handle navigation between app-level pages
class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.onboarding); // App starts on onboarding (or AppPage.home for testing)

  // Keep track of navigation history for back button functionality
  final List<AppPage> _history = [AppPage.onboarding]; // Initialize with the starting page

  /// Generic method to navigate to a new page and add it to history
  void navigateTo(AppPage newPage) {
    // Only add to history if it's a new page (not navigating back to the current page)
    if (_history.last != newPage) {
      _history.add(newPage);
    }
    debugPrint('Navigating from ${state} to $newPage. History: ${_history.map((e) => e.toString().split('.').last)}');
    emit(newPage);
  }

  /// Check if there's a page to pop back to
  bool canPop() => _history.length > 1;

  /// Pop the last page from history and emit the previous page
  void pop() {
    if (canPop()) {
      final currentPage = _history.removeLast(); // Remove current page
      debugPrint('Popping from $currentPage to ${_history.last}. History: ${_history.map((e) => e.toString().split('.').last)}');
      emit(_history.last); // Emit the new last page in history
    } else {
      debugPrint('Cannot pop: History has only one page or is empty.');
    }
  }

  // Specific navigation methods for clarity
  void navigateToOnboarding() => navigateTo(AppPage.onboarding);
  void navigateToRegistration() => navigateTo(AppPage.registration);
  void navigateToLogin() => navigateTo(AppPage.login);
  void navigateToHome() => navigateTo(AppPage.home);
  void navigateToDriverScreen() => navigateTo(AppPage.driver);
  void navigateToCustomerScreen() => navigateTo(AppPage.customer);

  // You can also add a method like this if you want to clear history and go to a specific page
  void navigateAndClearHistory(AppPage newPage) {
    _history.clear();
    _history.add(newPage);
    debugPrint('Navigating to $newPage and clearing history. History: ${_history.map((e) => e.toString().split('.').last)}');
    emit(newPage);
  }
}