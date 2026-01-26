import 'package:flutter/material.dart';

class StorageTile extends StatelessWidget {
  final String cacheSize;
  final bool isClearing;
  final VoidCallback onClear;

  const StorageTile({
    super.key,
    required this.cacheSize,
    required this.isClearing,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: colorScheme.surfaceContainer,
      leading: const Icon(Icons.storage),
      title: const Text('Offline Storage'),
      subtitle: Text('Audio cache: $cacheSize'),
      trailing: isClearing
          ? const SizedBox(width: 24, height: 24)
          : IconButton(onPressed: onClear, icon: const Icon(Icons.delete)),
    );
  }
}
