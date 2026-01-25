import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/song_model.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final VoidCallback onTap;
  final Widget? trailing;

  const SongTile({
    super.key,
    required this.song,
    this.isPlaying = false,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: song.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
              errorWidget: (context, url, error) =>
                  Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
            ),
            if (isPlaying)
              Container(
                color: Colors.black54,
                child: const Icon(Icons.equalizer, color: Colors.white),
              ),
          ],
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: isPlaying ? FontWeight.w900 : FontWeight.normal,
          color: isPlaying ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        song.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: trailing,
    );
  }
}
