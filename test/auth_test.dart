import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test(
        "Shouldn't be initialize to begin with",
        () => expect(provider.isInitialized, false),
      );

      test(
        "Can't execute command if not initialize",
        () async {
          expect(
            provider.signOut(),
            throwsA(
              const TypeMatcher<NotInitializeException>(),
            ),
          );
        },
      );

      test(
        'Should be able to initialize in less than 2 sec',
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );

      test(
        'Should current user null after initialize',
        () async {
          expect(provider.currentUser, null);
        },
      );

      test(
        'Create user should delegate to signin function',
        () async {
          final badEmail = provider.createUser(
            email: 'foo@bar.com',
            password: 'good',
          );

          expect(
            badEmail,
            throwsA(
              const TypeMatcher<UserNotFoundException>(),
            ),
          );

          final badPassword = provider.createUser(
            email: 'goodEmail',
            password: 'foobar',
          );

          expect(
            badPassword,
            throwsA(
              const TypeMatcher<WrongPasswordException>(),
            ),
          );

          final user = await provider.createUser(
            email: 'foo',
            password: 'baz',
          );
          expect(provider.currentUser, user);
          expect(user?.isEmailVerified, false);
        },
      );

      test(
        'User email should be verified after login',
        () async {
          provider.sendEmailVerification();
          final user = provider.currentUser;
          expect(user, isNotNull);
          expect(user?.isEmailVerified, true);
        },
      );

      test(
        'should be able to login again if logout occurs',
        () async {
          await provider.signOut();
          await provider.loginUser(
            email: 'email',
            password: 'password',
          );
          final user = provider.currentUser;
          expect(user, isNotNull);
        },
      );
    },
  );
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  bool _isInitialized = false;
  AuthUser? _user;
  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return loginUser(email: email, password: password);
  }

  @override
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) NotInitializeException();
    if (email == 'foo@bar.com') throw UserNotFoundException();
    if (password == 'foobar') throw WrongPasswordException();
// await Future.delayed(const Duration(seconds: 1));
    _user = AuthUser(id: '1', email: email);
    return Future.value(_user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) NotInitializeException();
    if (_user == null) throw UserNotFoundException();
    // await Future.delayed(const Duration(seconds: 1));
    _user = const AuthUser(id: '1', email: 'foo', isEmailVerified: true);
  }

  @override
  Future<void> signOut() async {
    if (!isInitialized) NotInitializeException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
}
