import '../../models/secundary models/devices.dart';
import 'player_service.dart';
import 'player_page.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/connection_status.dart';

class PlayerController {
  static final PlayerController _instance = PlayerController._();
  static PlayerController get instance => _instance;

  Timer? playerTimer;

  ValueNotifier<int> playerCurrentPosition = ValueNotifier(0);
  ValueNotifier<int> playertotal = ValueNotifier(0);

  //UniqueInstance
  PlayerController._();

  Stream<PlayerState>? playerState =
      SpotifySdk.subscribePlayerState().asBroadcastStream();

  Stream<ConnectionStatus>? playerContext =
      SpotifySdk.subscribeConnectionStatus();

  restartListeners() {
    playerState = null;
    playerContext = null;

    playerState = SpotifySdk.subscribePlayerState().asBroadcastStream();
    playerContext = SpotifySdk.subscribeConnectionStatus();
  }

  Future<void> showPlayerDialog(BuildContext context) async {
    try {
      if (context.mounted) {
        getPlayerState().then((initialPlayerState) {
          return showGeneralDialog(
            pageBuilder: (context, animation, secondaryAnimation) {
              return Container();
            },
            // ignore: use_build_context_synchronously
            context: context,
            transitionBuilder: (BuildContext context, a1, a2, widget) =>
                SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0, 0.5), end: const Offset(0, 0))
                        .animate(
                            CurvedAnimation(parent: a1, curve: Curves.ease)),
                    child: PlayerPage(initialPlayerState: initialPlayerState)),
          );
        });
      }
    } catch (e) {
      // AuthController().verifyAppConnection();
    }
  }

  Future<PlayerState?> getPlayerState() async {
    return await SpotifySdk.getPlayerState();
  }

  playSong(String? contextUri) async {
    await SpotifySdk.play(spotifyUri: contextUri ?? '');
  }

  playIndexPlaylist(int? trackIndex, String? contextUri) async {
    await SpotifySdk.skipToIndex(
        spotifyUri: contextUri ?? '', trackIndex: trackIndex ?? 0);
  }

  resume() async {
    await SpotifySdk.resume();
  }

  pause() async {
    await SpotifySdk.pause();
  }

  skipNext() async {
    await SpotifySdk.skipNext();
  }

  skipPrevious() async {
    await SpotifySdk.skipPrevious();
  }

  seekTo(int seek) {
    SpotifySdk.seekTo(positionedMilliseconds: seek);
  }

  void resumePlayerProgress() {
    if (playerTimer?.isActive ?? false) {
      playerTimer!.cancel();
    }

    playerTimer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (timer) {
        if (playerCurrentPosition.value >= playertotal.value) {
          pausePlayerProgress();
        }

        playerCurrentPosition.value += 1000;
      },
    );
  }

  void pausePlayerProgress() {
    if (playerTimer != null) {
      playerTimer!.cancel();
    }
  }

  Future<List<Devices>> getAvailableDevices() async {
    try {
      return await PlayerService().getAvailableDevices();
    } on Exception {
      rethrow;
    }
  }

  Future<void> transferPlayback(String? deviceId) async {
    try {
      if (deviceId != null || deviceId!.isNotEmpty) {
        return await PlayerService().transferPlayback(deviceId);
      }

      throw Exception('DeviceId invalid in TransferPlayblack');
    } on Exception {
      rethrow;
    }
  }
}
