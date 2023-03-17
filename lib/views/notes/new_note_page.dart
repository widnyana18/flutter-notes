import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/services/crud/notes_service.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  late final NotesService _notesService;
  DatabaseNote? _note;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email);
    final note = await _notesService.createNote(owner);
    _note = note;
    return note;
  }

  void _deleteNoteIfEmpty() async {
    if (_textController.text.isEmpty && _note != null) {
      await _notesService.deleteNote(_note!.id);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final text = _textController.text;
    if (text.isNotEmpty && _note != null) {
      await _notesService.updateNote(
        note: _note!,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    if (_note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(
      note: _note!,
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
    _textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpTextController();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
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
