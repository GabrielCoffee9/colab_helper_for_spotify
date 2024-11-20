import '../../models/primary models/user_profile_model.dart';
import '../../models/secundary models/artist_model.dart';
import '../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import '../../shared/widgets/spotify_free_warning_dialog.dart';
import '../artist/artist_page.dart';
import 'widgets/devices_dialog.dart';
import 'widgets/mini_player.dart';
import 'widgets/queue_dialog.dart';
import 'player_controller.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/library_state.dart';

class PlayerBottomSheet extends StatefulWidget {
  const PlayerBottomSheet({super.key});

  @override
  State<PlayerBottomSheet> createState() => _PlayerBottomSheetState();
}

class _PlayerBottomSheetState extends State<PlayerBottomSheet> {
  PlayerController playerController = PlayerController.instance;
  int _playerCurrentPosition = 0;
  LibraryState? libraryState;
  String? _songUri = '';
  final double bottomSheetMinSize = 0.07;
  final double bottomSheetMaxSize = 0.15;

  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  ValueNotifier<double> miniPlayerOpacity = ValueNotifier(0);

  PlayerState? initialPlayerStateData;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getLibraryState(String? spotifyUri) async {
    playerController.getLibraryState(spotifyUri ?? '').then((value) {
      setState(() {
        libraryState = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    playerController.getPlayerState().then((data) {
      setState(() {
        initialPlayerStateData = data;
      });

      if (data?.track != null) {
        miniPlayerOpacity.value = 1;
      }
      playerController.playerCurrentPosition.value =
          data?.playbackPosition ?? 0;
    });

    if (playerController.playerCurrentPosition.value == 0) {
      playerController.playerCurrentPosition.value =
          initialPlayerStateData?.playbackPosition ?? 0;
    }
    if (playerController.playerStateListener != null) {
      playerController.playerStateListener!.listen((data) {
        playerController.playerCurrentPosition.value = data.playbackPosition;
        playerController.playertotal.value = data.track?.duration ?? 0;
      });
    }

    playerController.playerCurrentPosition.addListener(() {
      setState(() {
        _playerCurrentPosition = playerController.playerCurrentPosition.value;
      });
    });

    draggableScrollableController.addListener(() {
      double size = draggableScrollableController.size;

      if (size < bottomSheetMinSize) {
        miniPlayerOpacity.value = 1;
        playerController.miniPlayerDisplay.value = 0;
      } else if (size > 0.15) {
        miniPlayerOpacity.value = 0;
        playerController.miniPlayerDisplay.value = 60;
      } else {
        miniPlayerOpacity.value = (0.15 - size) / (0.15 - bottomSheetMinSize);
        playerController.miniPlayerDisplay.value =
            ((size - bottomSheetMinSize) / (0.15 - bottomSheetMinSize) * 50);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool currentUserIsFree = UserProfile.instance.isFreeUser;

    final ColorScheme colors = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      controller: draggableScrollableController,
      initialChildSize: bottomSheetMinSize,
      minChildSize: bottomSheetMinSize,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          children: [
            if (initialPlayerStateData != null)
              StreamBuilder<PlayerState>(
                  initialData: initialPlayerStateData,
                  stream: playerController.playerStateListener,
                  builder: (context, snapshot) {
                    if (snapshot.data?.isPaused ?? true) {
                      playerController.pausePlayerProgress();
                    } else {
                      playerController.resumePlayerProgress();
                    }

                    bool canSkipPrevious =
                        snapshot.data?.playbackRestrictions.canSkipPrevious ??
                            false;

                    bool canSkipNext =
                        snapshot.data?.playbackRestrictions.canSkipNext ??
                            false;

                    bool isPodcast = snapshot.data?.track?.isPodcast ?? false;

                    if (_songUri != snapshot.data?.track?.uri) {
                      _songUri = snapshot.data?.track?.uri;
                      getLibraryState(_songUri);
                    }

                    return Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: miniPlayerOpacity,
                            builder: (context, value, child) {
                              return MiniPlayer(
                                opacityValue: value,
                                gestureDectectorOnTap: () {
                                  if (draggableScrollableController.size ==
                                      bottomSheetMinSize) {
                                    draggableScrollableController.animateTo(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 350),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                    scrollController.animateTo(80,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.fastOutSlowIn);
                                  }
                                },
                                trackImageUri: snapshot
                                    .data?.track?.imageUri.raw
                                    .split(':')[2],
                                trackName: snapshot.data?.track?.name ??
                                    LocalizationsController.of(context)!
                                        .loading,
                                trackArtistName: isPodcast
                                    ? snapshot.data?.track?.album.name ??
                                        LocalizationsController.of(context)!
                                            .loading
                                    : snapshot.data?.track?.artist.name ??
                                        LocalizationsController.of(context)!
                                            .loading,
                                playerCurrentPosition: _playerCurrentPosition,
                                trackDuration:
                                    snapshot.data?.track?.duration ?? 0,
                                isplaying: !(snapshot.data?.isPaused ?? true),
                                playAndPauseButtonPressed: () {
                                  if (snapshot.data?.isPaused ?? true) {
                                    playerController.resume();
                                  } else {
                                    playerController.pause();
                                  }
                                },
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  draggableScrollableController.animateTo(
                                    0.07,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 34,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 1,
                                    minWidth: 1,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        playerController.playerContext.value
                                                ?.subtitle ??
                                            '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        playerController
                                                .playerContext.value?.title ??
                                            LocalizationsController.of(context)!
                                                .loading,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Image.asset(
                            'lib/assets/Spotify_Logo_RGB_Green.png',
                            scale: 2.5,
                            cacheWidth: 413,
                            cacheHeight: 124,
                          ),
                        ),
                        if (snapshot.data?.track?.imageUri != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 12.0,
                            bottom: 12.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 315,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data?.track?.name ??
                                            LocalizationsController.of(context)!
                                                .loading,
                                        maxLines: isPodcast ? 2 : 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      isPodcast
                                          ? Text(
                                              snapshot.data?.track?.album
                                                      .name ??
                                                  LocalizationsController.of(
                                                          context)!
                                                      .loading,
                                              style: TextStyle(
                                                  color: colors.outline),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ArtistPage(
                                                      initialArtistData: Artist(
                                                          id: snapshot
                                                              .data
                                                              ?.track
                                                              ?.artist
                                                              .uri
                                                              ?.split(':')[2]),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                  snapshot.data?.track?.artist
                                                          .name ??
                                                      LocalizationsController
                                                              .of(context)!
                                                          .loading,
                                                  style: TextStyle(
                                                    color: colors.outline,
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: libraryState?.isSaved ?? false
                                      ? () {
                                          playerController.removeFromLibrary(
                                              snapshot.data?.track?.uri ?? '');
                                          _songUri = '';
                                        }
                                      : () {
                                          playerController.addToLibrary(
                                              snapshot.data?.track?.uri ?? '');
                                          _songUri = '';
                                        },
                                  icon: Image.asset(
                                    libraryState?.isSaved ?? false
                                        ? 'lib/assets/like_icon_liked.png'
                                        : 'lib/assets/like_icon_like.png',
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
                            ignoring: currentUserIsFree,
                            child: ProgressBar(
                              thumbRadius: currentUserIsFree ? 0 : 10.0,
                              onSeek: currentUserIsFree
                                  ? null
                                  : ((value) => playerController
                                      .seekTo(value.inMilliseconds)),
                              progress: Duration(
                                  milliseconds: _playerCurrentPosition),
                              total: Duration(
                                  milliseconds:
                                      snapshot.data?.track?.duration ?? 0),
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
                                      builder: (context) =>
                                          const DevicesDialog());
                                },
                                icon: Icon(
                                  Icons.devices_rounded,
                                  color: colors.primary,
                                ),
                              ),
                              isPodcast
                                  ? IconButton(
                                      onPressed: () {
                                        playerController
                                            .seekToRelativePosition(-15000);
                                      },
                                      icon: Row(
                                        children: [
                                          Icon(
                                            Icons.keyboard_double_arrow_left,
                                            color: colors.primary,
                                          ),
                                          Text(
                                            '15s',
                                            style: TextStyle(
                                                color: colors.primary),
                                          ),
                                        ],
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: canSkipPrevious
                                            ? colors.primary
                                            : Colors.blueGrey,
                                        size: 34,
                                      ),
                                      onPressed: canSkipPrevious
                                          ? () =>
                                              playerController.skipPrevious()
                                          : () {
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const SpotifyFreeWarningDialog(),
                                                );
                                              }
                                            },
                                    ),
                              snapshot.data?.isPaused ?? true
                                  ? SizedBox(
                                      height: 60,
                                      width: 100,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            colors.primary,
                                          ),
                                        ),
                                        onPressed: () =>
                                            playerController.resume(),
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
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  colors.primary),
                                        ),
                                        onPressed: () =>
                                            playerController.pause(),
                                        child: Icon(
                                          Icons.pause,
                                          color: colors.onPrimary,
                                          size: 42,
                                        ),
                                      ),
                                    ),
                              isPodcast
                                  ? IconButton(
                                      onPressed: () {
                                        playerController
                                            .seekToRelativePosition(15000);
                                      },
                                      icon: Row(
                                        children: [
                                          Text(
                                            '15s',
                                            style: TextStyle(
                                                color: colors.primary),
                                          ),
                                          Icon(
                                            Icons.keyboard_double_arrow_right,
                                            color: colors.primary,
                                          ),
                                        ],
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: canSkipNext
                                            ? colors.primary
                                            : Colors.blueGrey,
                                        size: 34,
                                      ),
                                      onPressed: canSkipNext
                                          ? () => playerController.skipNext()
                                          : () {
                                              if (context.mounted) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const SpotifyFreeWarningDialog());
                                              }
                                            },
                                    ),
                              IconButton(
                                onPressed: currentUserIsFree
                                    ? () {
                                        if (context.mounted) {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const SpotifyFreeWarningDialog());
                                        }
                                      }
                                    : () {
                                        if (context.mounted) {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const QueueDialog());
                                        }
                                      },
                                icon: Icon(
                                  color: currentUserIsFree
                                      ? Colors.blueGrey
                                      : colors.primary,
                                  Icons.queue_music,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [],
                        ),
                        const SizedBox(height: 120)
                      ],
                    );
                  })
          ],
        );
      },
    );
  }
}
