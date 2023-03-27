part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class UninitializeState extends AuthState {
  const UninitializeState();
}

class AuthenticatedState extends AuthState {
  final AuthUser user;
  const AuthenticatedState(this.user);
}

class RegisteringState extends AuthState {
  final Exception? error;
  const RegisteringState(this.error);
}

class NeedVerificationState extends AuthState {
  const NeedVerificationState();
}

class UnauthenticatedState extends AuthState with EquatableMixin {
  final Exception? error;
  final bool isLoading;

  const UnauthenticatedState({
    this.error,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [error, isLoading];
}
