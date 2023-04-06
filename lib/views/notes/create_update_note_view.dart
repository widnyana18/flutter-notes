import 'package:flutter/material.dart';
import 'package:flutter_begineer/extentions/context/loc.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_begineer/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:flutter_begineer/utils/generics/get_argument.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  late final FirebaseCloudStorage _notesService;
  CloudNote? _note;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  Future<CloudNote> createOrGetNote() async {
    final argsNote = context.getArgument<CloudNote>();
    if (argsNote != null) {
      _textController.text = argsNote.text;
      _note = argsNote;
      return argsNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(note.documentId);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        docId: note.documentId,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(
      docId: note.documentId,
      text: text,
    );
  }

  void _setUpTextController() async {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.note),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCantShareEmptyNoteDialog(context);
              }
              await Share.share(text);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpTextController();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: context.loc.start_typing_your_note,
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
