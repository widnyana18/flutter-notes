import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_begineer/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String userId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.userId,
    required this.text,
  });

  CloudNote.fromSnaphot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : documentId = doc.id,
        userId = doc.data()[userIdName] as String,
        text = doc.data()[textFieldName] as String;

  @override
  String toString() =>
      'Database user{id: $documentId, userId: $userId, text: $text}';

  @override
  bool operator ==(covariant CloudNote other) => documentId == other.documentId;

  @override
  int get hashCode => documentId.hashCode;
}
