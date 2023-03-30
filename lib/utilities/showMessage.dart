import 'package:flutter/material.dart';

Future<bool> ShowMessage(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirmation Box"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Continue"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
