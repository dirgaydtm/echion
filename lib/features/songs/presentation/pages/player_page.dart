import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/player_provider.dart';
import '../../../../core/widgets/snackbar_helper.dart';
import '../widgets/album.dart';
import '../widgets/progress_slider.dart';
import '../widgets/player_control.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final song = playerState.currentSong;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<PlayerState>(playerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackBar(context, next.error!);
        });
      }
    });

    if (song == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No song playing')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
          iconSize: 32,
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Album(imageUrl: song.thumbnailUrl),
            const Spacer(),

            Text(
              song.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            ProgressSlider(
              position: playerState.position,
              duration: playerState.duration,
              onChanged: (duration) {
                ref.read(playerProvider.notifier).seek(duration);
              },
            ),

            const SizedBox(height: 24),

            PlayerControls(
              isPlaying: playerState.isPlaying,
              isBuffering: playerState.isBuffering,
              hasPrevious: playerState.hasPrevious,
              hasNext: playerState.hasNext,
              onPlayPause: () => ref.read(playerProvider.notifier).playPause(),
              onPrevious: () => ref.read(playerProvider.notifier).previous(),
              onNext: () => ref.read(playerProvider.notifier).next(),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
