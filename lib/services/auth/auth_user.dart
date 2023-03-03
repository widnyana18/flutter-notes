import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool? isEmailVerified;
  const AuthUser({this.isEmailVerified});

  factory AuthUser.formFirebase(User user) {
    return AuthUser(isEmailVerified: user.emailVerified);
  }
}
