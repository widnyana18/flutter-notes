import 'package:flutter/material.dart';
import 'package:flutter_begineer/utils/dialogs/generic_dialog.dart';

Future<void> showCantShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context,
    title: 'Sharing',
    content: 'Error cant share because note is empty',
    optionsBuilder: () => {'OKE': null},
  );
}
