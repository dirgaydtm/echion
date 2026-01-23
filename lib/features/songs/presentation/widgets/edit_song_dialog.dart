import 'package:flutter/material.dart';

Future<(String, String)?> showEditSongDialog({
  required BuildContext context,
  required String initialTitle,
  required String initialArtist,
}) async {
  final titleController = TextEditingController(text: initialTitle);
  final artistController = TextEditingController(text: initialArtist);

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Song'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: artistController,
            decoration: const InputDecoration(
              labelText: 'Artist',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );

  if (result == true) {
    return (titleController.text, artistController.text);
  }
  return null;
}
