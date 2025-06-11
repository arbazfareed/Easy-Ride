part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  // Potentially add user data here later: final User? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    // this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage, // Allow null to clear error
    // User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      // user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage]; //, user];
}
