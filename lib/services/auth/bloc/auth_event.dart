part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class InitializeEvent extends AuthEvent {
  const InitializeEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterEvent({
    required this.email,
    required this.password,
  });
}

class ResetPasswordByEmailEvent extends AuthEvent {
  final String? email;
  const ResetPasswordByEmailEvent(this.email);
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPsw;
  const UpdatePasswordEvent(this.newPsw);
}

class NeedRegisterEvent extends AuthEvent {
  const NeedRegisterEvent();
}

class VerifyEmailEvent extends AuthEvent {
  const VerifyEmailEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
