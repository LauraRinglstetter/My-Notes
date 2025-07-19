import 'package:flutter/material.dart';

Future<String?> showShareNoteDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Mit wem möchtest du diese Notiz teilen?'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'E-Mail-Adresse',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              Navigator.of(context).pop(email.isEmpty ? null : email);
            },
            child: const Text('Teilen'),
          ),
        ],
      );
    },
  );
}
