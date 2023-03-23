part of 'notes_service.dart';

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idCol = 'id';
const emailCol = 'email';
const userIdCol = 'user_id';
const textCol = 'text';
const isSyncedWithCloudCol = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
