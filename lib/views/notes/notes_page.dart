import 'package:flutter/material.dart';
import 'package:flutter_begineer/constants/routes.dart';
import 'package:flutter_begineer/extentions/context/loc.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_begineer/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_begineer/utils/dialogs/logout_dialog.dart';
import 'package:flutter_begineer/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout }

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
            stream: _notesService.allNotes(userId).getLength,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final count = snapshot.data ?? 0;
                final text = context.loc.notes_title(count);
                return Text(text);
              } else {
                return const Text('');
              }
            }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              if (value == MenuAction.logout) {
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(
                        const LogoutEvent(),
                      );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuAction.logout,
                child: Text(context.loc.logout_button),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(note.documentId);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
