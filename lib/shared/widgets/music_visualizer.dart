import 'unit_audio_wave.dart';

import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  /// Max to 8 waves.
  final int unitAudioWavecount;

  final double? height;
  final double? width;
  final double lineWidth;
  final double circularBorderRadius;

  const MusicVisualizer({
    super.key,
    required this.unitAudioWavecount,
    this.height,
    this.width,
    required this.lineWidth,
    this.circularBorderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    List<int> durations = [680, 900, 780, 650, 720, 700, 800, 750];
    durations.shuffle();

    List<double> lineHeight = [8, 25, 12, 16, 20, 15, 11, 8];

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(unitAudioWavecount, (index) {
          lineHeight.shuffle();
          durations.shuffle();
          return UnitAudioWave(
            duration: durations[index],
            lineHeight: lineHeight[index],
            lineWidth: lineWidth,
            color: Theme.of(context).colorScheme.primary,
          );
        }),
      ),
    );
  }
}
