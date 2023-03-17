import 'package:flutter/material.dart';

typedef OptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>(
  BuildContext context, {
  required String title,
  required String content,
  required OptionsBuilder<T> optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: options.keys.map(
        (title) {
          final value = options[title];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(title),
          );
        },
      ).toList(),
    ),
  );
}
