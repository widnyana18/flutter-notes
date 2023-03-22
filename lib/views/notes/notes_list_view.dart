import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/crud/notes_service.dart';
import 'package:flutter_begineer/utils/dialogs/delete_dialog.dart';

// typedef NoteCallback = void Function(DatabaseNote note);

// class NotesListView extends StatelessWidget {
//   final List<DatabaseNote> allNotes;
//   final NoteCallback onDeleteNote;
//   final NoteCallback onTap;
//   const NotesListView({
//     super.key,
//     required this.allNotes,
//     required this.onDeleteNote,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: allNotes.length,
//       itemBuilder: (context, index) {
//         final note = allNotes[index];
//         return ListTile(
//           onTap: () {
//             onTap(note);
//           },
//           title: Text(
//             note.text,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             softWrap: true,
//           ),
//           trailing: IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () async {
//               final shouldDelete = await showDeleteDialog(context);
//               if (shouldDelete) {
//                 onDeleteNote(note);
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
