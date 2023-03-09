import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_begineer/firebase_options.dart';
import 'package:flutter_begineer/services/auth/auth_exceptions.dart';
import 'package:flutter_begineer/services/auth/auth_provider.dart';
import 'package:flutter_begineer/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.formFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (currentUser != null) {
        return currentUser;
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        case 'invalid-email':
          throw InvalidEmailException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (currentUser != null) {
        return currentUser;
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException();

        case 'wrong-password':
          throw WrongPasswordException();

        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await user?.sendEmailVerification();
    } else {
      throw UserNotLoginException();
    }
  }

  @override
  Future<void> signOut() async {
    if (currentUser != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoginException();
    }
  }
}
