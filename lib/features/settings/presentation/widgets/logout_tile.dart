import 'package:flutter/material.dart';

class LogoutTile extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutTile({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: colorScheme.surfaceContainer,
      leading: Icon(Icons.logout, color: colorScheme.error),
      title: Text('Logout', style: TextStyle(color: colorScheme.error)),
      onTap: onLogout,
    );
  }
}