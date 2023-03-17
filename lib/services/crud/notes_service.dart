import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_begineer/services/crud/notes_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;
  List<DatabaseNote> _notes = [];
  late final StreamController<List<DatabaseNote>> _notesController;

  NotesService._sharedInstance() {
    _notesController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesController.sink.add(_notes);
      },
    );
  }

  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  Stream<List<DatabaseNote>> get allNotes => _notesController.stream;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesController.add(_notes);
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    } else {
      try {
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _db = db;
        await db.execute(dropUserTable);
        await db.execute(createUserTable);
        await db.execute(dropNoteTable);
        await db.execute(createNoteTable);
        await _cacheNotes();
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentDirectory();
      }
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<DatabaseUser> getOrCreateUser(String email) async {
    try {
      final user = await getUser(email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseUser> createUser(String email) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    } else {
      final userId = await db.insert(
        userTable,
        {emailCol: email.toLowerCase()},
      );
      return DatabaseUser(id: userId, email: email);
    }
  }

  Future<DatabaseUser> getUser(String email) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<void> deleteUser(String email) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getUser(email);
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount == 0) throw CouldNotDeleteUser();
  }

  Future<DatabaseNote> createNote(DatabaseUser owner) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    const text = '';

    await getUser(owner.email);

    final noteId = await db.insert(
      noteTable,
      {
        userIdCol: owner.id,
        textCol: text,
        isSyncedWithCloudCol: 1,
      },
    );

    if (noteId == 0) {
      throw CouldNotAddNote();
    } else {
      final newNote = DatabaseNote(
        id: noteId,
        userId: owner.id,
        text: text,
        isSyncedWithCloud: true,
      );
      _notes.add(newNote);
      _notesController.add(_notes);

      return newNote;
    }
  }

  Future<DatabaseNote> getNote(int id) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNote.fromRow(results.first);
      _notes.removeWhere((item) => item.id == note.id);
      _notes.add(note);
      _notesController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(noteTable);

    return results.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(note.id);

    final noteId = await db.update(
      noteTable,
      {
        textCol: text,
        isSyncedWithCloudCol: 0,
      },
    );

    if (noteId == 0) {
      throw CouldNotUpdateNote();
    } else {
      final newNote = await getNote(note.id);
      _notes.removeWhere((note) => note.id == newNote.id);
      _notes.add(newNote);
      _notesController.add(_notes);
      return newNote;
    }
  }

  Future<void> deleteNote(int id) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id);
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final totalDeletions = await db.delete(noteTable);
    _notes = [];
    _notesController.add(_notes);
    return totalDeletions;
  }
}

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
      'Database user{id: $id, userId: $userId, text: $text, isSyncedWithCloud: $isSyncedWithCloud}';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const String dbName = 'notes.db';
const String userTable = 'user';
const String noteTable = 'note';
const String idCol = 'id';
const String emailCol = 'email';
const String userIdCol = 'user_id';
const String textCol = 'text';
const String isSyncedWithCloudCol = 'is_synced_with_cloud';
const String createUserTable = '''CREATE TABLE "user" (
	"id"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const String createNoteTable = '''CREATE TABLE "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const String dropUserTable = 'DROP TABLE IF EXISTS "user"';
const String dropNoteTable = 'DROP TABLE IF EXISTS "note"';
