part of 'auth_service.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  });
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  });
  Future<void> sendPasswordReset(String email);
  Future<void> sendEmailVerification();
  Future<void> signOut();
}
