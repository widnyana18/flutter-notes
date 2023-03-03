import 'package:flutter_begineer/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  });
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> sendEmailVerification();
}
