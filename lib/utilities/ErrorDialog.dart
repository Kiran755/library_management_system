import 'package:flutter/material.dart';

Future<void> showError(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  // pop out of the dialog box only
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        );
      });
}
