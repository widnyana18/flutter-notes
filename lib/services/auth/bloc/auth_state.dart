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

class UnauthenticatedState extends AuthState {
  final Exception? error;
  const UnauthenticatedState(this.error);
}

class LogoutFailedState extends AuthState {
  final Exception error;
  const LogoutFailedState(this.error);
}

class NeedVerificationState extends AuthState {
  const NeedVerificationState();
}
