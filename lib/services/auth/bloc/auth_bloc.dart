import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
            emit(AuthenticatedState(user: user));
          } else {
            emit(const NeedVerificationState());
          }
        } else {
          emit(const UnauthenticatedState(error: null));
        }
      } catch (_) {
        emit(const UninitializeState());
      }
    });

    on<LoginEvent>((event, emit) async {
      final email = event.email;
      final psw = event.password;

      try {
        emit(const UnauthenticatedState(
          error: null,
          isLoading: true,
        ));
        final user = await provider.loginUser(
          email: email,
          password: psw,
        );
        if (!user!.isEmailVerified) {
          emit(const NeedVerificationState());
        } else {
          emit(AuthenticatedState(user: user));
        }
      } on Exception catch (e) {
        emit(UnauthenticatedState(error: e));
      }
    });

    on<NeedRegisterEvent>((event, emit) async {
      emit(const RegisteringState(null));
    });

    on<RegisterEvent>((event, emit) async {
      final email = event.email;
      final psw = event.password;

      try {
        await provider.createUser(
          email: email,
          password: psw,
        );
        emit(const NeedVerificationState());
      } on Exception catch (e) {
        emit(RegisteringState(e));
      }
    });

    on<VerifyEmailEvent>((event, emit) async {
      final user = provider.currentUser!;
      try {
        emit(const NeedVerificationState(isLoading: true));
        await provider.sendEmailVerification();
        emit(AuthenticatedState(user: user));
      } on Exception catch (_) {
        emit(const NeedVerificationState());
      }
    });

    on<LogoutEvent>((event, emit) async {
      final user = provider.currentUser;
      try {
        if (user != null) {
          emit(AuthenticatedState(
            user: user,
            isLoading: true,
          ));
          await provider.signOut();
        }
        emit(const UnauthenticatedState(error: null));
      } on Exception catch (e) {
        emit(UnauthenticatedState(error: e));
      }
    });
  }
}
