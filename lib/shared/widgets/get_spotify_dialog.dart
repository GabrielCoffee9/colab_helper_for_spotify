import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetSpotifyDialog extends StatefulWidget {
  const GetSpotifyDialog({super.key});

  @override
  State<GetSpotifyDialog> createState() => _GetSpotifyDialogState();
}

class _GetSpotifyDialogState extends State<GetSpotifyDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Your device doesn't have the Spotify app installed"),
      contentPadding: const EdgeInsets.all(20),
      children: [
        SizedBox(
          height: 150,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Colab Helper uses the Spotify app to sync and play tracks, please install Spotify before use this app.'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: OutlinedButton(
                  onPressed: () {
                    final url =
                        Uri.parse("market://details?id=com.spotify.music");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text('GET SPOTIFY FREE'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
