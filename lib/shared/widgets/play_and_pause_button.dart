import 'package:flutter/material.dart';

class PlayAndPauseButton extends StatelessWidget {
  const PlayAndPauseButton(
      {super.key, required this.playing, this.onPressed, this.size = 35});
  final bool playing;
  final void Function()? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return playing
        ? IconButton.filled(
            icon: Icon(
              size: size,
              Icons.pause_outlined,
            ),
            onPressed: onPressed,
          )
        : IconButton.filled(
            icon: Icon(
              size: size,
              Icons.play_arrow_outlined,
              color: colors.onPrimary,
            ),
            onPressed: onPressed,
          );
  }
}
