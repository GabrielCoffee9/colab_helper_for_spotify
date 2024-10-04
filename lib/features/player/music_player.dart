import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:colab_helper_for_spotify/features/player/player_controller.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:transparent_image/transparent_image.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key, required this.initialPlayerState});
  final PlayerState? initialPlayerState;
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  PlayerController playerController = PlayerController.instance;
  int _playerCurrentPosition = 0;

  @override
  void initState() {
    if (playerController.playerCurrentPosition.value == 0) {
      playerController.playerCurrentPosition.value =
          widget.initialPlayerState?.playbackPosition ?? 0;
    }

    playerController.playerState.listen((data) {
      playerController.playerCurrentPosition.value = data.playbackPosition;
      playerController.playertotal.value = data.track?.duration ?? 0;
    });

    playerController.playerCurrentPosition.addListener(() {
      if (mounted) {
        setState(() {
          _playerCurrentPosition = playerController.playerCurrentPosition.value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              'lib/assets/Spotify_Logo_RGB_Green.png',
              scale: 15,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 34,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: StreamBuilder<PlayerState>(
            initialData: widget.initialPlayerState,
            stream: playerController.playerState,
            builder: (context, snapshot) {
              if (snapshot.data?.isPaused ?? true) {
                playerController.stopPlayerTimer();
              } else {
                playerController.startPlayerTimer();
              }
              return Column(
                textDirection: TextDirection.ltr,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FadeInImage.memoryNetwork(
                        imageScale: 1.78,
                        placeholder: kTransparentImage,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const EmptyPlaylistCover(
                            height: 355,
                            width: 355,
                            size: 60,
                          );
                        },
                        image:
                            'https://i.scdn.co/image/${snapshot.data?.track?.imageUri.raw.split(':')[2]}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 315,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.track?.name ?? 'Loading',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  snapshot.data?.track?.artist.name ??
                                      'Loading',
                                  style: TextStyle(color: colors.outline),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 355,
                    height: 20,
                    child: ProgressBar(
                        onSeek: ((value) =>
                            playerController.seekTo(value.inMilliseconds)),
                        progress:
                            Duration(milliseconds: _playerCurrentPosition),
                        total: Duration(
                            milliseconds: snapshot.data?.track?.duration ?? 0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.devices_rounded),
                        ),
                        IconButton(
                          icon: CircleAvatar(
                            backgroundColor: colors.onSecondary,
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: colors.primary,
                              size: 34,
                            ),
                          ),
                          onPressed: () async =>
                              await playerController.skipPrevious(),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: snapshot.data?.isPaused ?? true
                              ? SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(
                                                colors.primaryContainer)),
                                    onPressed: () async =>
                                        playerController.resume(),
                                    child: const Icon(
                                      Icons.play_arrow_outlined,
                                      size: 42,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(
                                                colors.primaryContainer)),
                                    onPressed: () async =>
                                        playerController.pause(),
                                    child: const Icon(
                                      Icons.pause,
                                      size: 42,
                                    ),
                                  ),
                                ),
                        ),
                        IconButton(
                          icon: CircleAvatar(
                            backgroundColor: colors.onSecondary,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: colors.primary,
                              size: 34,
                            ),
                          ),
                          onPressed: () async =>
                              await playerController.skipNext(),
                        ),
                        IconButton(
                          onPressed: () => playerController.startPlayerTimer(),
                          icon: const Icon(Icons.queue_music),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
