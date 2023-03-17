import 'package:flutter/material.dart';

Future<T?> showGenericDialog<T>(
  BuildContext context, {
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
