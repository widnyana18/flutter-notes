class CloudStorageException implements Exception {}

class CloudNotCreateNoteException extends CloudStorageException {}

class CloudNotUpdateNoteException extends CloudStorageException {}

class CloudNotGetAllNotesException extends CloudStorageException {}

class CloudNotDeleteNoteException extends CloudStorageException {}
