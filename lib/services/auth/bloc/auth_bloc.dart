import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_begineer/services/auth/auth_service.dart'
    show AuthUser, AuthProvider;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider provider;
  AuthBloc(this.provider) : super(const UninitializeState()) {
    on<InitializeEvent>((event, emit) async {
      try {
        await provider.initialize();
        final user = provider.currentUser;

        if (user != null) {
          if (user.isEmailVerified) {
            emit(AuthenticatedState(user));
          } else {
            emit(const NeedVerificationState());
          }
        } else {
          emit(const UnauthenticatedState(null));
        }
      } catch (_) {
        emit(const UninitializeState());
      }
    });

    on<LoginEvent>((event, emit) async {
      // emit(const UninitializeState());
      try {
        final user = await provider.loginUser(
          email: event.email,
          password: event.password,
        );
        emit(AuthenticatedState(user!));
      } on Exception catch (e) {
        emit(UnauthenticatedState(e));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(const UninitializeState());
      try {
        await provider.signOut();
        emit(const UnauthenticatedState(null));
      } on Exception catch (e) {
        emit(LogoutFailedState(e));
      }
    });
  }
}
