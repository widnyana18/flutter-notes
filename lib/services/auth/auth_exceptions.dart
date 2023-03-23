part of 'auth_service.dart';

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

class GenericAuthException implements Exception {}

class UserNotLoginException implements Exception {}
