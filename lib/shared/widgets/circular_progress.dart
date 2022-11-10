import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress(
      {super.key,
      required this.backgroundColor,
      required this.circularColor,
      required this.isDone});
  final Color backgroundColor, circularColor;

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: Center(
        child: isDone
            ? Icon(
                Icons.done,
                size: 52,
                color: circularColor,
              )
            : CircularProgressIndicator(
                color: circularColor,
              ),
      ),
    );
  }
}
