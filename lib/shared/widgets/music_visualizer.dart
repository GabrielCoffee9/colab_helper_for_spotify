import 'package:colab_helper_for_spotify/shared/widgets/unit_audio_wave.dart';
import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  const MusicVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> durations = [680, 780, 900, 800, 700, 650, 720, 750];
    durations.shuffle();

    List<double> lineHeight = [8, 12, 16, 25, 20, 15, 11, 8];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
          8,
          (index) => UnitAudioWave(
                duration: durations[index],
                lineHeight: lineHeight[index],
                color: Theme.of(context).colorScheme.primary,
              )),
    );
  }
}
