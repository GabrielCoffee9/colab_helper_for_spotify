import '../../models/primary models/user_profile_model.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import 'widgets/devices_dialog.dart';
import 'player_controller.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.initialPlayerState});
  final PlayerState? initialPlayerState;
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  PlayerController playerController = PlayerController.instance;
  int _playerCurrentPosition = 0;

  @override
  void initState() {
    if (playerController.playerCurrentPosition.value == 0) {
      playerController.playerCurrentPosition.value =
          widget.initialPlayerState?.playbackPosition ?? 0;
    }
    if (playerController.playerState != null) {
      playerController.playerState!.listen((data) {
        playerController.playerCurrentPosition.value = data.playbackPosition;
        playerController.playertotal.value = data.track?.duration ?? 0;
      });
    }

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
    bool freeUser = (UserProfile.instance.product ?? 'free') == 'free';

    final ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: const Text("Playing now on"),
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
                playerController.pausePlayerProgress();
              } else {
                playerController.resumePlayerProgress();
              }

              bool canSkipPrevious =
                  snapshot.data?.playbackRestrictions.canSkipPrevious ?? false;

              bool canSkipNext =
                  snapshot.data?.playbackRestrictions.canSkipNext ?? false;

              return Column(
                textDirection: TextDirection.ltr,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      'lib/assets/Spotify_Logo_RGB_Green.png',
                      scale: 2.5,
                      cacheWidth: 413,
                      cacheHeight: 124,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity! > 0) {
                          if (canSkipPrevious) {
                            if (_playerCurrentPosition > 2000) {
                              playerController.skipPrevious();
                            }
                            playerController.skipPrevious();
                          }
                        } else if (details.primaryVelocity! < 0) {
                          if (canSkipNext) {
                            playerController.skipNext();
                          }
                        }
                      },
                      child: SizedBox(
                        height: 360,
                        width: 360,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const EmptyPlaylistCover(),
                          errorWidget: (context, url, error) =>
                              const EmptyPlaylistCover(),
                          imageUrl:
                              'https://i.scdn.co/image/${snapshot.data?.track?.imageUri.raw.split(':')[2]}',
                          imageBuilder: (context, image) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              image: DecorationImage(image: image),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                            icon: Image.asset(
                              'lib/assets/like_icon_like.png',
                              height: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 355,
                    height: 20,
                    child: IgnorePointer(
                      ignoring: freeUser,
                      child: ProgressBar(
                        thumbRadius: freeUser ? 0 : 10.0,
                        onSeek: freeUser
                            ? null
                            : ((value) =>
                                playerController.seekTo(value.inMilliseconds)),
                        progress:
                            Duration(milliseconds: _playerCurrentPosition),
                        total: Duration(
                            milliseconds: snapshot.data?.track?.duration ?? 0),
                      ),
                    ),
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
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => const DevicesDialog());
                          },
                          icon: Icon(
                            Icons.devices_rounded,
                            color: colors.primary,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: canSkipPrevious
                                ? colors.primary
                                : Colors.blueGrey,
                            size: 34,
                          ),
                          onPressed: canSkipPrevious
                              ? () => playerController.skipPrevious()
                              : null,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: snapshot.data?.isPaused ?? true
                              ? SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        colors.primary,
                                      ),
                                    ),
                                    onPressed: () => playerController.resume(),
                                    child: Icon(
                                      Icons.play_arrow_outlined,
                                      color: colors.onPrimary,
                                      size: 42,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          colors.primary),
                                    ),
                                    onPressed: () => playerController.pause(),
                                    child: Icon(
                                      Icons.pause,
                                      color: colors.onPrimary,
                                      size: 42,
                                    ),
                                  ),
                                ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color:
                                canSkipNext ? colors.primary : Colors.blueGrey,
                            size: 34,
                          ),
                          onPressed: canSkipNext
                              ? () => playerController.skipNext()
                              : null,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(color: colors.primary, Icons.queue_music),
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
