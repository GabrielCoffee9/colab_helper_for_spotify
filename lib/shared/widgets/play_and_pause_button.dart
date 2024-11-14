import 'package:flutter/material.dart';

class PlayAndPauseButton extends StatelessWidget {
  const PlayAndPauseButton({super.key, required this.playing, this.onPressed});
  final bool playing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return playing
        ? IconButton.filled(
            icon: const Icon(
              size: 35,
              Icons.pause_outlined,
            ),
            onPressed: onPressed,
          )
        : IconButton.filled(
            icon: Icon(
              size: 35,
              Icons.play_arrow_outlined,
              color: colors.onPrimary,
            ),
            onPressed: onPressed,
          );
  }
}
