import 'package:colab_helper_for_spotify/shared/static/color_schemes.g.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatefulWidget {
  const AppLogo({super.key, required this.iconSize, required this.darkTheme});

  final bool darkTheme;
  final double iconSize;

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(children: [
        SizedBox(
          height: widget.iconSize,
          width: widget.iconSize,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: widget.darkTheme
                    ? darkColorScheme.primary
                    : lightColorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
        ),
        Icon(
          Icons.play_arrow_outlined,
          size: widget.iconSize,
          color: widget.darkTheme
              ? darkColorScheme.onPrimary
              : lightColorScheme.onPrimary,
        ),
      ]),
    );
  }
}
