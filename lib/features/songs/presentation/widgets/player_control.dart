import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPlayPause,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: hasPrevious ? onPrevious : null,
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 40,
        ),
        const SizedBox(width: 16),
        
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: isBuffering
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
                  onPressed: onPlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: colorScheme.onPrimary,
                  ),
                  iconSize: 48,
                  padding: const EdgeInsets.all(12),
                ),
        ),
        
        const SizedBox(width: 16),
        IconButton(
          onPressed: hasNext ? onNext : null,
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 40,
        ),
      ],
    );
  }
}