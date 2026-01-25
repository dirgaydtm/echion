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
      backgroundColor: ColorScheme.dark().surfaceContainer,
      title: Text(
        'Edit Song',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              expands: false,
              maxLines: 1,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: artistController,
              expands: false,
              maxLines: 1,
              decoration: const InputDecoration(labelText: 'Artist'),
            ),
          ],
        ),
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
