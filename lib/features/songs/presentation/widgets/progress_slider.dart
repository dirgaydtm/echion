import 'package:flutter/material.dart';

class ProgressSlider extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const ProgressSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onChanged,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.5),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: position.inMilliseconds.toDouble().clamp(
              0,
              duration.inMilliseconds.toDouble(),
            ),
            max: duration.inMilliseconds.toDouble().clamp(1, double.infinity),
            onChanged: (value) {
              onChanged(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
