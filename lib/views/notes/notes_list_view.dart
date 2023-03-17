import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/crud/notes_service.dart';
import 'package:flutter_begineer/utils/dialogs/generic_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> allNotes;
  final DeleteNoteCallback onDeleteNote;
  const NotesListView({
    required this.allNotes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allNotes.length,
      itemBuilder: (context, index) {
        final note = allNotes[index].text;
        return ListTile(
          title: Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if(shouldDele)
            },
          ),
        );
      },
    );
  }
}
