import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_begineer/services/cloud/cloud_note.dart';
import 'package:flutter_begineer/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_begineer/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  FirebaseCloudStorage._sharedInstance();
  static final _shared = FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  final _notes = FirebaseFirestore.instance.collection(collectionName);

  void createNewNote(String userId) async {
    try {
      await _notes.add({userIdName: userId, textFieldName: ''});
    } catch (e) {
      throw CloudNotCreateNoteException();
    }
  }

  Future<void> updateNote({
    required String docId,
    required String text,
  }) async {
    try {
      await _notes.doc(docId).update({textFieldName: text});
    } catch (e) {
      throw CloudNotUpdateNoteException();
    }
  }

  Future<void> deleteNote(String docId) async {
    try {
      await _notes.doc(docId).delete();
    } catch (e) {
      throw CloudNotDeleteNoteException();
    }
  }

  Future<Iterable<CloudNote>> getNotes(String userId) async {
    try {
      return await _notes
          .where(
            userIdName,
            isEqualTo: userId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnaphot(doc),
            ),
          );
    } catch (e) {
      throw CloudNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes() {
    return _notes.snapshots().map(
          (event) => event.docs.map(
            (doc) => CloudNote.fromSnaphot(doc),
          ),
        );
  }
}
