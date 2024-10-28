import 'package:flutter/material.dart';

class UnitAudioWave extends StatefulWidget {
  const UnitAudioWave(
      {super.key,
      required this.duration,
      required this.lineHeight,
      required this.color});

  final int duration;
  final double lineHeight;
  final Color color;

  @override
  State<UnitAudioWave> createState() => _UnitAudioWaveState();
}

class _UnitAudioWaveState extends State<UnitAudioWave>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutCubicEmphasized);

    animation =
        Tween<double>(begin: 2, end: widget.lineHeight).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
      height: animation.value,
    );
  }
}
