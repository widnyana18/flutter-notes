import 'package:flutter/material.dart';
import 'package:flutter_begineer/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context, {
  required String content,
}) {
  return showGenericDialog(
    context,
    title: 'An error occurred',
    content: content,
    optionsBuilder: () => {'OKE': null},
  );
}
