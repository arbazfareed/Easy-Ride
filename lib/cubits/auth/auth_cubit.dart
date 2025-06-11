import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Uncomment if you are using Firebase Auth

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // final FirebaseAuth _firebaseAuth; // Uncomment if you are using Firebase Auth

  AuthCubit(/*{required FirebaseAuth firebaseAuth}*/) : super(const AuthState()) {
    // If you are using Firebase Auth, you would set up a stream listener here
    // _firebaseAuth = firebaseAuth;
    // _firebaseAuth.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     emit(state.copyWith(status: AuthStatus.authenticated));
    //   } else {
    //     emit(state.copyWith(status: AuthStatus.unauthenticated));
    //   }
    // });
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null)); // Clear previous errors
    try {
      // --- Replace with your actual backend authentication logic ---
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Example with Firebase Auth:
      // await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // Simulate success
      emit(state.copyWith(status: AuthStatus.authenticated));
      // -----------------------------------------------------------

    } on Exception catch (e) { // Catch specific exceptions if needed (e.g., FirebaseAuthException)
      print("Login error: $e");
      String message = "Login failed. Please check your credentials.";
      // You can parse specific error messages here if you have a backend error code
      // if (e is FirebaseAuthException) {
      //   if (e.code == 'user-not-found') {
      //     message = 'No user found for that email.';
      //   } else if (e.code == 'wrong-password') {
      //     message = 'Wrong password provided for that user.';
      //   }
      // }
      emit(state.copyWith(status: AuthStatus.error, errorMessage: message));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      // await _firebaseAuth.signOut(); // Uncomment if using Firebase
      await Future.delayed(const Duration(seconds: 1)); // Simulate logout
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Logout failed.'));
    }
  }

  void clearErrorMessage() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }
}
