// lib/cubits/registration/registration_state.dart

// Enum to represent distinct steps in the registration flow
enum RegistrationStep {
  name,          // For first and last name input
  phone,         // For phone number input
  emailPassword, // For email and password input
  completed,     // Indicates the entire registration process is successfully done
}

class RegistrationState {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password; // NEW: Added to store the user's chosen password
  final RegistrationStep currentStep; // CHANGED: Using enum for better step management
  final String? errorMessage; // NEW: For displaying validation or Firebase errors
  final bool isLoading; // NEW: To indicate if an operation (like Firebase save) is in progress

  const RegistrationState({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.currentStep,
    this.errorMessage,
    this.isLoading = false,
  });

  // Factory constructor to provide an initial, clean state
  factory RegistrationState.initial() {
    return const RegistrationState(
      firstName: '',
      lastName: '',
      phone: '',
      email: '',
      password: '',
      currentStep: RegistrationStep.name, // The registration flow starts with the name step
      isLoading: false,
    );
  }

  // Helper method to create a new state instance with updated values
  RegistrationState copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    RegistrationStep? currentStep,
    String? errorMessage, // Allows setting null to clear the message
    bool? isLoading,
  }) {
    return RegistrationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      currentStep: currentStep ?? this.currentStep,
      errorMessage: errorMessage, // This correctly allows null to clear the error
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
