import 'package:flutter/material.dart';
import 'package:flutter_begineer/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context,
    title: 'Delete',
    content: 'Are you sure you want delete?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
