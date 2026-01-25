import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/player_provider.dart';
import '../pages/player_page.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(playerProvider.select((s) => s.currentSong));
    final isPlaying = ref.watch(playerProvider.select((s) => s.isPlaying));
    final isBuffering = ref.watch(playerProvider.select((s) => s.isBuffering));
    final colorScheme = Theme.of(context).colorScheme;

    if (song == null) return const SizedBox.shrink();

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 400),
      closedColor: colorScheme.surfaceContainer,
      openColor: colorScheme.surface,
      closedElevation: 0,
      openElevation: 0,
      closedShape: const RoundedRectangleBorder(),
      openBuilder: (context, _) => const PlayerPage(),
      closedBuilder: (context, openContainer) => Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorScheme.outline)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorScheme.surface,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
                errorWidget: (context, url, error) =>
                    Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: isBuffering
                      ? null
                      : () => ref.read(playerProvider.notifier).previous(),
                  highlightColor: Colors.transparent,
                ),
                SizedBox(
                  width: 24,
                  height: 48,
                  child: Center(
                    child: isBuffering
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : IconButton(
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                            onPressed: () =>
                                ref.read(playerProvider.notifier).playPause(),
                          ),
                  ),
                ),
                IconButton(
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.skip_next),
                  onPressed: isBuffering
                      ? null
                      : () => ref.read(playerProvider.notifier).next(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
