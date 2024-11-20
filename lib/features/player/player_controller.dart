import '../../models/secundary models/devices_model.dart';
import '../../models/secundary models/queue_model.dart';
import '../../shared/modules/app_remote/app_remote_handler.dart';
import 'player_service.dart';

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

  Stream<PlayerState>? playerStateListener;

  Stream<PlayerContext>? playerContextListener;

  ValueNotifier<double> miniPlayerDisplay = ValueNotifier(0);

  //UniqueInstance
  PlayerController._() {
    playerStateListener = SpotifySdk.subscribePlayerState().asBroadcastStream();

    playerContextListener =
        SpotifySdk.subscribePlayerContext().asBroadcastStream();

    playerContextListener!.listen((data) {
      playerContext.value = data;
    });
  }

  restartListeners() {
    playerStateListener = null;

    playerStateListener = SpotifySdk.subscribePlayerState().asBroadcastStream();

    playerContextListener = null;

    playerContextListener =
        SpotifySdk.subscribePlayerContext().asBroadcastStream();

    playerContextListener!.listen((data) {
      playerContext.value = data;
    });
  }

  // Future<void> showPlayerDialog(BuildContext context) async {
  //   try {
  //     if (context.mounted) {
  //       getPlayerState().then((initialPlayerState) {
  //         return showGeneralDialog(
  //           pageBuilder: (context, animation, secondaryAnimation) {
  //             return Container();
  //           },
  //           // ignore: use_build_context_synchronously
  //           context: context,
  //           transitionBuilder: (BuildContext context, a1, a2, widget) =>
  //               SlideTransition(
  //             position: Tween<Offset>(
  //               begin: const Offset(0, 0.5),
  //               end: const Offset(0, 0),
  //             ).animate(
  //               CurvedAnimation(parent: a1, curve: Curves.ease),
  //             ),
  //             child: PlayerBottomSheet(initialPlayerStateData: initialPlayerState),
  //           ),
  //         );
  //       });
  //     }
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  Future<PlayerState?> getPlayerState() async {
    return await appRemoteHandler<PlayerState?>(
      () => SpotifySdk.getPlayerState(),
    );
  }

  play(String? contextUri) async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.play(spotifyUri: contextUri ?? ''),
    );
  }

  skipToIndex(int? trackIndex, String? contextUri) async {
    return await appRemoteHandler<dynamic>(
      () => SpotifySdk.skipToIndex(
          spotifyUri: contextUri ?? '', trackIndex: trackIndex ?? 0),
    );
  }

  queue(String? contextUri) async {
    return await appRemoteHandler<dynamic>(
      () => SpotifySdk.queue(
        spotifyUri: contextUri ?? '',
      ),
    );
  }

  resume() async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.resume(),
    );
  }

  pause() async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.pause(),
    );
  }

  skipNext() async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.skipNext(),
    );
  }

  skipPrevious() async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.skipPrevious(),
    );
  }

  seekTo(int seek) async {
    await appRemoteHandler<dynamic>(
        () => SpotifySdk.seekTo(positionedMilliseconds: seek));
  }

  seekToRelativePosition(int seek) async {
    await appRemoteHandler<dynamic>(
      () => SpotifySdk.seekToRelativePosition(relativeMilliseconds: seek),
    );
  }

  setPlaybackSpeed(double playbackSpeed) async {
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

    await appRemoteHandler<dynamic>(
      () => SpotifySdk.setPodcastPlaybackSpeed(
          podcastPlaybackSpeed: newPlaybackSpeed),
    );
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
      final response = await PlayerService().getAvailableDevices();

      List<Devices> devicesList = [];

      for (var element in response.data['devices']) {
        var newDevice = Devices.fromJson(element);

        devicesList.add(newDevice);
      }

      return devicesList;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> transferPlayback(String? deviceId) async {
    try {
      if (deviceId == null || deviceId.isEmpty) {
        throw Exception('DeviceId invalid at TransferPlayblack');
      }
      final response = await PlayerService().transferPlayback(deviceId);

      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } on Exception {
      rethrow;
    }
  }

  Future<Queue> getUserQueue() async {
    try {
      final response = await PlayerService().getUserQueue();

      return Queue.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  addToLibrary(String? spotifyUri) async {
    try {
      if (spotifyUri != null && spotifyUri.isEmpty) {
        throw Exception('The given spotifyUri is null or empty');
      }

      await appRemoteHandler<dynamic>(
        () => SpotifySdk.addToLibrary(spotifyUri: spotifyUri!),
      );
    } on Exception {
      rethrow;
    }
  }

  removeFromLibrary(String? spotifyUri) async {
    try {
      if (spotifyUri != null && spotifyUri.isEmpty) {
        throw Exception('The given spotifyUri is null or empty');
      }

      await appRemoteHandler<dynamic>(
        () => SpotifySdk.removeFromLibrary(spotifyUri: spotifyUri!),
      );
    } on Exception {
      rethrow;
    }
  }

  Future<LibraryState?> getLibraryState(String spotifyUri) async {
    return await appRemoteHandler<LibraryState?>(
      () => SpotifySdk.getLibraryState(spotifyUri: spotifyUri),
    );
  }
}
