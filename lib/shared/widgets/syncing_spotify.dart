import '../../features/auth/auth_controller.dart';
import '../../features/player/player_controller.dart';
import '../modules/appLocalizations/localizations_controller.dart';
import 'circular_progress.dart';

import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

class SyncingSpotify extends StatefulWidget {
  const SyncingSpotify({super.key});

  @override
  State<SyncingSpotify> createState() => _SyncingSpotifyState();
}

class _SyncingSpotifyState extends State<SyncingSpotify> {
  @override
  void initState() {
    super.initState();

    retry(
      () {
        AuthController.instance.syncSpotifyRemote().whenComplete(() {
          PlayerController.instance.restartListeners();
        });
      },
      retryIf: (_) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(LocalizationsController.of(context)!.syncLost),
      children: [
        SizedBox(
          height: 150,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgress(isDone: false),
              Text(LocalizationsController.of(context)!.syncPlsWait)
            ],
          ),
        ),
      ],
    );
  }
}
