part of 'firebase_cloud_storage.dart';

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
      'Cloud Note{id: $documentId, userId: $userId, text: $text}';

  @override
  bool operator ==(covariant CloudNote other) => documentId == other.documentId;

  @override
  int get hashCode => documentId.hashCode;
}
