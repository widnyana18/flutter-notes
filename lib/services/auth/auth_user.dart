part of 'auth_service.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  const AuthUser({
    required this.id,
    required this.email,
    this.isEmailVerified = false,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      id: user.uid,
      isEmailVerified: user.emailVerified,
      email: user.email!,
    );
  }

  @override
  String toString() =>
      'Auth User{id: $id, email: $email, isEmailVerified: $isEmailVerified}';

  @override
  bool operator ==(covariant AuthUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
