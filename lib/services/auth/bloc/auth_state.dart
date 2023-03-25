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

class LoginFailedState extends AuthState {
  final Exception error;
  const LoginFailedState(this.error);
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class LogoutFailedState extends AuthState {
  final Exception error;
  const LogoutFailedState(this.error);
}

class NeedVerificationState extends AuthState {
  const NeedVerificationState();
}
