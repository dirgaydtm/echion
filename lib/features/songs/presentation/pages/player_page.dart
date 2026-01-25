import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/player_provider.dart';
import '../../../../core/utils/snackbar_helper.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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
            Container(
              height: 340,
              width: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainer,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

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

            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    inactiveTrackColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: playerState.position.inMilliseconds.toDouble().clamp(
                      0,
                      playerState.duration.inMilliseconds.toDouble(),
                    ),
                    max: playerState.duration.inMilliseconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                    onChanged: (value) {
                      ref
                          .read(playerProvider.notifier)
                          .seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(playerState.position),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(playerState.duration),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: playerState.hasPrevious
                      ? () => ref.read(playerProvider.notifier).previous()
                      : null,
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 40,
                ),
                const SizedBox(width: 16),

                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: playerState.isBuffering
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () =>
                              ref.read(playerProvider.notifier).playPause(),
                          icon: Icon(
                            playerState.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: colorScheme.onPrimary,
                          ),
                          iconSize: 48,
                          padding: const EdgeInsets.all(12),
                        ),
                ),
                const SizedBox(width: 16),

                IconButton(
                  onPressed: playerState.hasNext
                      ? () => ref.read(playerProvider.notifier).next()
                      : null,
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 40,
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
