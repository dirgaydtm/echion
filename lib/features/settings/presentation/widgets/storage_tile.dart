import 'package:flutter/material.dart';

/// Storage/cache tile widget with clear button
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
    return ListTile(
      leading: const Icon(Icons.storage),
      title: const Text('Offline Storage'),
      subtitle: Text('Audio cache: $cacheSize'),
      trailing: isClearing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(onPressed: onClear, child: const Text('Clear')),
    );
  }
}
