import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_begineer/services/auth/auth_exceptions.dart';
import 'package:flutter_begineer/services/auth/auth_provider.dart';
import 'package:flutter_begineer/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (currentUser != null) {
        return currentUser;
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordException();
        // await showErrorDialog(context, 'Weak password');
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        // await showErrorDialog(context, 'Email already in use');
        case 'invalid-email':
          throw InvalidEmailException();
        // await showErrorDialog(context, 'Invalid email');
        default:
          throw GenericAuthException();
        // await showErrorDialog(context, e.code);
      }
    } catch (e) {
      throw GenericAuthException();
      // await showErrorDialog(context, e.toString());
    }
  }

  @override
  Future<AuthUser?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (currentUser?.isEmailVerified ?? false) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        throw UserNotLoginException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException();
        // await showErrorDialog(context, 'User not Found');

        case 'wrong-password':
          throw WrongPasswordException();
        // await showErrorDialog(context, 'Wrong Password');

        default:
          throw GenericAuthException();
        // await showErrorDialog(context, e.code);
      }
    } catch (e) {
      throw GenericAuthException();
      // await showErrorDialog(context, e.toString());
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
