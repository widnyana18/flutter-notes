part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    this.isLoading = false,
    this.loadingText = 'Please wait a moment',
  });
}

class UninitializeState extends AuthState {
  const UninitializeState();
}

class AuthenticatedState extends AuthState with EquatableMixin {
  final AuthUser user;
  const AuthenticatedState({
    required this.user,
    super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [user, isLoading, loadingText];
}

class RegisteringState extends AuthState {
  final Exception? error;
  const RegisteringState(this.error);
}

class ForgotPasswordState extends AuthState {
  final Exception? error;
  final bool hasSentEmail;

  const ForgotPasswordState({
    this.error,
    this.hasSentEmail = false,
    super.isLoading,
  });
}

class NeedVerificationState extends AuthState {
  const NeedVerificationState({
    super.isLoading,
    super.loadingText = 'Please wait while I log you in',
  });
}

class UnauthenticatedState extends AuthState with EquatableMixin {
  final Exception? error;

  const UnauthenticatedState({
    this.error,
    super.isLoading,
    super.loadingText = 'Please wait while I log you in',
  });

  @override
  List<Object?> get props => [error, isLoading, loadingText];
}
