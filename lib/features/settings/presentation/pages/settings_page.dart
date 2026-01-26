import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/snackbar_helper.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../songs/providers/song_provider.dart';
import '../../../songs/providers/player_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/profile_tile.dart';
import '../widgets/theme_picker.dart';
import '../widgets/storage_tile.dart';
import '../widgets/logout_tile.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Settings'),
      body: ListView(
        children: [
          if (authState.user != null) ...[
            const SizedBox(height: 16),
            ProfileTile(user: authState.user!),
          ],
          const SizedBox(height: 24),
          const SectionHeader('Appearance'),
          ThemePicker(
            selected: settingsState.themeMode,
            onChanged: (m) =>
                ref.read(settingsProvider.notifier).setThemeMode(m),
          ),
          const SizedBox(height: 24),
          const SectionHeader('Storage'),
          StorageTile(
            cacheSize: settingsState.cacheSize,
            isClearing: settingsState.isClearingCache,
            onClear: () => _clearCache(context, ref),
          ),

          const SizedBox(height: 24),
          const SectionHeader('Account'),
          LogoutTile(onLogout: () => _logout(context, ref)),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Clear Cache',
      message: 'This will delete all downloaded songs and images.',
      confirmLabel: 'Clear',
    );
    if (confirmed) {
      await ref.read(settingsProvider.notifier).clearCache();
      if (context.mounted) {
        showSnackBar(context, 'Cache cleared!');
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmLabel: 'Logout',
    );
    if (confirmed) {
      await ref.read(playerProvider.notifier).stop();
      await ref.read(songsProvider.notifier).clearData();
      await ref.read(settingsProvider.notifier).clearCache();
      await ref.read(authProvider.notifier).logout();
    }
  }
}
