import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_begineer/firebase_options.dart';

part 'auth_provider.dart';
part 'auth_exceptions.dart';
part 'auth_user.dart';
part 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  }) =>
      provider.loginUser(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> signOut() => provider.signOut();
}
