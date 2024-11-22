import '../../shared/static/color_schemes.g.dart';

import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key, required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode
              ? darkColorScheme.onPrimary
              : lightColorScheme.onPrimary),
      child: Center(
        child: isDone
            ? Icon(
                Icons.done,
                size: 52,
                color: isDarkMode
                    ? darkColorScheme.primary
                    : lightColorScheme.primary,
              )
            : CircularProgressIndicator(
                color: isDarkMode
                    ? darkColorScheme.primary
                    : lightColorScheme.primary,
              ),
      ),
    );
  }
}
