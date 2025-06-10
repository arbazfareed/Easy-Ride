// lib/cubits/registration/registration_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationState.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateFirstName(String value) {
    emit(state.copyWith(firstName: value, errorMessage: null));
  }

  void updateLastName(String value) {
    emit(state.copyWith(lastName: value, errorMessage: null));
  }

  void updatePhone(String value) {
    emit(state.copyWith(phone: value, errorMessage: null));
  }

  void updateEmail(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void updatePassword(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  Future<void> submitName() async {
    if (state.firstName.isEmpty || state.lastName.isEmpty) {
      emit(state.copyWith(errorMessage: "First name and last name cannot be empty."));
      return;
    }
    emit(state.copyWith(currentStep: RegistrationStep.phone, errorMessage: null));
  }

  Future<void> submitPhone() async {
    // Basic phone number validation (e.g., minimum length)
    if (state.phone.isEmpty || state.phone.length < 10) { // Example validation
      emit(state.copyWith(errorMessage: "Please enter a valid phone number."));
      return;
    }
    // Corrected: If validation passes, move to the next step (Email/Password)
    emit(state.copyWith(currentStep: RegistrationStep.emailPassword, errorMessage: null));
  }

  Future<void> submitEmailAndPassword() async {
    if (state.email.isEmpty || !state.email.contains('@') || !state.email.contains('.')) {
      emit(state.copyWith(errorMessage: "Please enter a valid email address."));
      return;
    }
    if (state.password.isEmpty || state.password.length < 6) {
      emit(state.copyWith(errorMessage: "Password must be at least 6 characters long."));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      await userCred.user?.sendEmailVerification();

      if (userCred.user != null) {
        final newUser = UserModel(
          uid: userCred.user!.uid,
          firstName: state.firstName,
          lastName: state.lastName,
          phone: state.phone,
          email: state.email,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(newUser.uid).set(newUser.toFirestore());
      } else {
        throw Exception("Firebase user creation failed unexpectedly.");
      }

      emit(state.copyWith(currentStep: RegistrationStep.completed, isLoading: false));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else {
        message = 'Authentication failed. Please try again later.';
      }
      emit(state.copyWith(errorMessage: message, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "An unexpected error occurred during registration. Please try again.",
        isLoading: false,
      ));
    }
  }

  void goBack() {
    if (state.currentStep == RegistrationStep.phone) {
      emit(state.copyWith(currentStep: RegistrationStep.name, errorMessage: null));
    } else if (state.currentStep == RegistrationStep.emailPassword) {
      emit(state.copyWith(currentStep: RegistrationStep.phone, errorMessage: null));
    }
  }
}
