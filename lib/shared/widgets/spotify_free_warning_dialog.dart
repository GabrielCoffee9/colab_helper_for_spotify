import '../modules/appLocalizations/localizations_controller.dart';
import 'app_logo.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyFreeWarningDialog extends StatefulWidget {
  const SpotifyFreeWarningDialog({super.key});

  @override
  State<SpotifyFreeWarningDialog> createState() =>
      _SpotifyFreeWarningDialogState();
}

class _SpotifyFreeWarningDialogState extends State<SpotifyFreeWarningDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return SimpleDialog(
      title: Text(LocalizationsController.of(context)!.enjoyThisFeature),
      contentPadding: const EdgeInsets.all(20),
      children: [
        SizedBox(
          height: 250,
          width: 300,
          child: Column(
            children: [
              Text(LocalizationsController.of(context)!.colabFollowsPlansRules),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(iconSize: 50, darkTheme: isDarkMode),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.favorite),
                    ),
                    Image.asset(
                      'lib/assets/Spotify_Icon_RGB_Green.png',
                      height: 50,
                    ),
                  ],
                ),
              ),
              Text(LocalizationsController.of(context)!.thisActionIsPremium),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: LocalizationsController.of(context)!
                          .spotifyPremiumLets,
                      style: TextStyle(color: colors.onSurface),
                    ),
                    TextSpan(
                      style: TextStyle(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      text: 'spotify.com/premium',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          final url =
                              Uri.parse("https://www.spotify.com/premium/");
                          launchUrl(
                            url,
                            mode: LaunchMode.platformDefault,
                          );
                        },
                    ),
                    TextSpan(
                      text: LocalizationsController.of(context)!.toTryit,
                      style: TextStyle(color: colors.onSurface),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
