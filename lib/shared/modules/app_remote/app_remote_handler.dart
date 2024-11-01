import '../../../features/auth/auth_service.dart';
import '../../../features/player/player_controller.dart';

import 'dart:developer';

import 'package:flutter/services.dart';

Future<T?> appRemoteHandler<T>(Future<T> Function() sdkFunction) async {
  try {
    return await sdkFunction();
  } on PlatformException catch (e) {
    if (e.details ==
        'com.spotify.android.appremote.api.error.SpotifyDisconnectedException') {
      final confirmation = await handleSpotifyDisconnectedException();

      if (confirmation) {
        PlayerController.instance.restartListeners();
        return await sdkFunction();
      }
    }
  } catch (e) {
    log("Spotify Handler - Unhandled exception -> $e");
  }
  return null;
}

Future<bool> handleSpotifyDisconnectedException() async {
  try {
    final confirmation =
        await AuthService().getNewTokenAndConnectToSpotifyRemote();
    log("SpotifyDisconnectedException handled");
    return confirmation;
  } catch (e) {
    log('Spotify Handler - Unexpected error at handling disconnect -> $e');
    return false;
  }
}
