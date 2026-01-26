import 'package:flutter/material.dart';
import '../../../auth/data/user_model.dart';

class ProfileTile extends StatelessWidget {
  final UserModel user;

  const ProfileTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primary,
        radius: 28,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(color: colorScheme.onPrimary),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.email),
    );
  }
}
