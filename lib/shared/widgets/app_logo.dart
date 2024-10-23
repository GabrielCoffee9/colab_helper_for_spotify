import '../static/color_schemes.g.dart';

import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.iconSize, required this.darkTheme});

  final bool darkTheme;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(children: [
        SizedBox(
          height: iconSize,
          width: iconSize,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: darkTheme
                    ? darkColorScheme.primary
                    : lightColorScheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(iconSize / 10)),
              ),
            ),
          ),
        ),
        Icon(
          Icons.play_arrow_outlined,
          size: iconSize,
          color: darkTheme
              ? darkColorScheme.onPrimary
              : lightColorScheme.onPrimary,
        ),
      ]),
    );
  }
}
