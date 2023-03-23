import 'dart:async';
import 'package:flutter_begineer/extentions/list/filter.dart';
import 'package:flutter_begineer/services/crud/database_note.dart';
import 'package:flutter_begineer/services/crud/notes_constans.dart';
import 'package:flutter_begineer/services/crud/notes_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;
  DatabaseUser? _user;
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

  Stream<List<DatabaseNote>> get allNotes {
    return _notesController.stream.filter(
      (note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw NotesShouldSpecifyWithCurrentUser();
        }
      },
    );
  }

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
        await db.execute(createUserTable);
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

  Future<DatabaseUser> getOrCreateUser(String email,
      {setAsCurrentUser = true}) async {
    try {
      final user = await getUser(email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
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
      where: 'id = ?',
      whereArgs: [note.id],
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
