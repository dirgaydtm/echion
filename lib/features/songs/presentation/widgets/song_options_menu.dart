import 'package:flutter/material.dart';

class SongOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SongOptionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [Icon(Icons.delete), SizedBox(width: 8), Text('Delete')],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
    );
  }
}
