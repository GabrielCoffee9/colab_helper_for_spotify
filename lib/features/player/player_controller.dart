import '../../models/secundary models/devices.dart';
import '../../models/secundary models/queue.dart';
import 'player_service.dart';
import 'player_dialog.dart';

import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/library_state.dart';
import 'package:spotify_sdk/models/player_context.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class PlayerController {
  static final PlayerController _instance = PlayerController._();
  static PlayerController get instance => _instance;

  Timer? playerTimer;

  ValueNotifier<int> playerCurrentPosition = ValueNotifier(0);
  ValueNotifier<int> playertotal = ValueNotifier(0);

  ValueNotifier<PlayerContext?> playerContext = ValueNotifier(null);

  //UniqueInstance
  PlayerController._() {
    SpotifySdk.subscribePlayerContext().listen((event) {
      playerContext.value = event;
    });
  }

  Stream<PlayerState>? playerState =
      SpotifySdk.subscribePlayerState().asBroadcastStream();

  restartListeners() {
    playerState = null;

    playerState = SpotifySdk.subscribePlayerState().asBroadcastStream();
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
                            begin: const Offset(0, 0.5),
                            end: const Offset(0, 0))
                        .animate(
                            CurvedAnimation(parent: a1, curve: Curves.ease)),
                    child:
                        PlayerDialog(initialPlayerState: initialPlayerState)),
          );
        });
      }
    } on Exception {
      rethrow;
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

  seekToRelativePosition(int seek) {
    SpotifySdk.seekToRelativePosition(relativeMilliseconds: seek);
  }

  setPlaybackSpeed(double playbackSpeed) {
    late PodcastPlaybackSpeed newPlaybackSpeed;

    switch (playbackSpeed) {
      case 0.5:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_50;

      case 0.8:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_80;

      case 1.0:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_100;

      case 1.2:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_120;

      case 1.5:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_150;

      case 2.0:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_200;

      case 3.0:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_300;

      default:
        newPlaybackSpeed = PodcastPlaybackSpeed.playbackSpeed_100;
    }

    SpotifySdk.setPodcastPlaybackSpeed(podcastPlaybackSpeed: newPlaybackSpeed);
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

  Future<Queue> getUserQueue() async {
    try {
      return await PlayerService().getUserQueue();
    } on Exception {
      rethrow;
    }
  }

  likeSong(String spotifyUri) async {
    SpotifySdk.addToLibrary(spotifyUri: spotifyUri);
  }

  deslikeSong(String spotifyUri) async {
    SpotifySdk.removeFromLibrary(spotifyUri: spotifyUri);
  }

  Future<LibraryState?> getLibraryState(String spotifyUri) async {
    return await SpotifySdk.getLibraryState(spotifyUri: spotifyUri);
  }
}
