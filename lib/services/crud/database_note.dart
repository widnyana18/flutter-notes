part of 'notes_service.dart';

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        email = map[emailCol] as String;

  @override
  String toString() => 'Database user{id: $id, email: $email}';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    this.isSyncedWithCloud = false,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        userId = map[userIdCol] as int,
        text = map[textCol] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudCol] as int) == 0 ? false : true;

  @override
  String toString() =>
      'Database Note{id: $id, userId: $userId, text: $text, isSyncedWithCloud: $isSyncedWithCloud}';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
