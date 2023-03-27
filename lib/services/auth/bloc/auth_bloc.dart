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
            emit(AuthenticatedState(user));
          } else {
            emit(const NeedVerificationState());
          }
        } else {
          emit(const UnauthenticatedState(
            error: null,
            isLoading: false,
          ));
        }
      } catch (_) {
        emit(const UninitializeState());
      }
    });

    on<LoginEvent>((event, emit) async {
      final email = event.email;
      final psw = event.password;

      emit(const UnauthenticatedState(
        error: null,
        isLoading: true,
      ));
      try {
        final user = await provider.loginUser(
          email: email,
          password: psw,
        );
        if (!user!.isEmailVerified) {
          emit(const UnauthenticatedState(
            error: null,
            isLoading: false,
          ));
          emit(const NeedVerificationState());
        } else {
          emit(const UnauthenticatedState(
            error: null,
            isLoading: false,
          ));
          emit(AuthenticatedState(user));
        }
      } on Exception catch (e) {
        emit(UnauthenticatedState(
          error: e,
          isLoading: false,
        ));
      }
    });

    on<NeedRegisterEvent>((event, emit) async {
      emit(const RegisteringState(null));
    });

    on<RegisterEvent>((event, emit) async {
      final email = event.email;
      final psw = event.password;

      // emit(const UnauthenticatedState(
      //   error: null,
      //   isLoading: true,
      // ));
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
      try {
        await provider.sendEmailVerification();
        final user = provider.currentUser!;
        emit(AuthenticatedState(user));
      } on Exception catch (_) {
        emit(const NeedVerificationState());
      }
    });

    on<LogoutEvent>((event, emit) async {
      // emit(const UnauthenticatedState(
      //   error: null,
      //   isLoading: true,
      // ));
      try {
        await provider.signOut();
        emit(const UnauthenticatedState(
          error: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(UnauthenticatedState(
          error: e,
          isLoading: false,
        ));
      }
    });
  }
}
