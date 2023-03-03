import 'package:flutter_begineer/services/auth/auth_provider.dart';
import 'package:flutter_begineer/services/auth/auth_user.dart';
import 'package:flutter_begineer/services/auth/firebase_auth_provider.dart';

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
