import '../../models/primary models/user_profile_model.dart';
import '../../models/secundary models/playlist_model.dart';
import '../../models/secundary models/track_model.dart';
import '../../shared/modules/user/user_controller.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import '../../shared/widgets/profile_picture.dart';
import '../../shared/widgets/song_tile.dart';
import '../player/player_controller.dart';
import 'playlist_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    super.key,
    required this.initialPlaylistData,
  });

  final Playlist initialPlaylistData;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  PlayerController playerController = PlayerController.instance;

  PlaylistController playlistController = PlaylistController();
  UserController userController = UserController();

  final ScrollController _scrollController = ScrollController();

  bool isPlaylistLoading = true;

  ValueNotifier<bool> currentUserFollowsPlaylist = ValueNotifier(false);

  Playlist playlist = Playlist();

  String selectedSongUri = "";
  String? playlistOwnerImageUrl;

  bool playerIsPaused = false;

  bool showScrollToTopButton = false;

  Future<void> getTracks({int offset = 0}) async {
    playlistController
        .getPlaylistTracks(playlist, UserProfile.instance.country, offset)
        .then((value) {
      setState(() {
        playlist = value;
        isPlaylistLoading = false;
      });
    });

    return;
  }

  void getOwnerPlaylistImageUrl() {
    userController.getUserUrlProfileImage(playlist.owner?.id).then((value) {
      setState(() {
        playlistOwnerImageUrl = value;
      });
    });
  }

  void checkIfUserFollowsPlaylist() {
    if (playlist.owner!.id != UserProfile.instance.id) {
      playlistController
          .checkIfCurrentUserFollowsPlaylist(playlist.id)
          .then((value) {
        currentUserFollowsPlaylist.value = value;
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    playlist = widget.initialPlaylistData;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300) {
        if (!showScrollToTopButton) {
          setState(() {
            showScrollToTopButton = true;
          });
        }
      } else {
        setState(() {
          showScrollToTopButton = false;
        });
      }
    });

    playerController.getPlayerState().then((data) {
      setState(() {
        selectedSongUri = data?.track?.uri ?? '';
        playerIsPaused = data?.isPaused ?? true;
      });
    });

    if (playerController.playerStateListener != null) {
      playerController.playerStateListener!.listen((data) {
        setState(() {
          selectedSongUri = data.track?.uri ?? '';
          playerIsPaused = data.isPaused;
        });
      });
    }

    getTracks();
    getOwnerPlaylistImageUrl();
    checkIfUserFollowsPlaylist();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      floatingActionButton: showScrollToTopButton
          ? FloatingActionButton(
              mini: true,
              child: const Icon(Icons.keyboard_double_arrow_up),
              onPressed: () {
                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastOutSlowIn);
              })
          : null,
      appBar: AppBar(
        primary: true,
        //Disabled for now.
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showDialog(
        //         context: context,
        //         builder: (context) {
        //           return AlertDialog(
        //             backgroundColor: colors.surface,
        //             title: const Text('Edit playlist details'),
        //             actions: [
        //               TextButton(onPressed: () {}, child: const Text('Cancel')),
        //               TextButton(onPressed: () {}, child: const Text('Save'))
        //             ],
        //           );
        //         },
        //       );
        //     },
        //     icon: const Icon(Icons.edit),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.search),
        //   )
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () => getTracks(),
        child: (isPlaylistLoading)
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgress(isDone: false),
                    Text('Loading'),
                  ],
                ),
              )
            : Scrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: CachedNetworkImage(
                              imageUrl: playlist.images!.isNotEmpty
                                  ? playlist.images!.first.url!
                                  : '',
                              memCacheWidth: 480,
                              memCacheHeight: 350,
                              maxWidthDiskCache: 480,
                              maxHeightDiskCache: 350,
                              imageBuilder: (context, image) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const EmptyPlaylistCover(),
                              errorWidget: (context, url, error) =>
                                  const EmptyPlaylistCover(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      isPlaylistLoading
                                          ? ''
                                          : playlist.name ?? 'Unnamed Playlist',
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          (playlist.owner?.id != 'spotify')
                                              ? SizedBox(
                                                  width: 60,
                                                  child: ProfilePicture(
                                                    imageUrl:
                                                        playlistOwnerImageUrl,
                                                    avatar: true,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'lib/assets/Spotify_Icon_RGB_Green.png',
                                                  height: 60,
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(playlist
                                                        .owner?.displayName ??
                                                    ''),
                                                Text(
                                                  "Playlist",
                                                  style: TextStyle(
                                                      color: colors.tertiary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (playlist.owner?.id !=
                                              UserProfile.instance.id)
                                            ListenableBuilder(
                                                listenable:
                                                    currentUserFollowsPlaylist,
                                                builder: (context, snapshot) {
                                                  return IconButton(
                                                    onPressed:
                                                        currentUserFollowsPlaylist
                                                                .value
                                                            ? () {
                                                                playerController
                                                                    .removeFromLibrary(
                                                                        playlist
                                                                            .uri);
                                                                checkIfUserFollowsPlaylist();
                                                              }
                                                            : () {
                                                                playerController
                                                                    .addToLibrary(
                                                                        playlist
                                                                            .uri);
                                                                checkIfUserFollowsPlaylist();
                                                              },
                                                    icon: Image.asset(
                                                      currentUserFollowsPlaylist
                                                              .value
                                                          ? 'lib/assets/like_icon_liked.png'
                                                          : 'lib/assets/like_icon_like.png',
                                                      height: 30,
                                                    ),
                                                  );
                                                }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox.square(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, left: 12, right: 12),
                          child: (playlist.tracks.isNotEmpty)
                              ? Wrap(
                                  children: [
                                    Text(
                                      playlist.description ?? '',
                                      style: TextStyle(
                                          color: colors.onSurfaceVariant),
                                    )
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Empty Playlist !!! ',
                                      style: TextStyle(
                                          fontSize: 22, color: colors.primary),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SliverReorderableList(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Track item = playlist.tracks.removeAt(oldIndex);
                          playlist.tracks.insert(newIndex, item);
                        });
                      },
                      itemCount: playlist.tracks.length,
                      itemBuilder: (context, index) {
                        if (index + 1 == (playlist.tracks.length) &&
                            ((playlist.total) > (index + 1)) &&
                            playlistController.state.value !=
                                PlaylistState.loading) {
                          getTracks(offset: index + 1);
                        }

                        if ((index + 1 >= (playlist.tracks.length)) &&
                            playlistController.state.value ==
                                PlaylistState.loading) {
                          return Column(
                            key: Key('$index'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              LinearProgressIndicator(),
                              Text('Loading')
                            ],
                          );
                        }

                        return Padding(
                          key: Key('$index'),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            key: Key('$index'),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: colors.outline, width: 0.5),
                              ),
                            ),
                            child: ReorderableDelayedDragStartListener(
                              enabled: false,
                              index: index,
                              child: SongTile(
                                key: Key('$index'),
                                songName: playlist.tracks[index].name,
                                artistName: playlist.tracks[index].allArtists,
                                imageUrl: playlist.tracks[index].album?.images
                                            .isNotEmpty ??
                                        false
                                    ? playlist
                                        .tracks[index].album!.images[1].url
                                    : '',
                                selected: selectedSongUri ==
                                    playlist.tracks[index].uri,
                                playingNow: (selectedSongUri ==
                                        playlist.tracks[index].uri) &&
                                    !playerIsPaused,
                                invalidTrack: playlist.tracks[index].invalid,
                                explicit:
                                    playlist.tracks[index].explicit ?? false,
                                onTap: () {
                                  setState(() {
                                    if (selectedSongUri ==
                                        playlist.tracks[index].uri) {
                                      playerIsPaused
                                          ? playerController.resume()
                                          : playerController.pause();
                                    } else {
                                      playerController.skipToIndex(
                                          index -
                                              (playlist.tracks[index]
                                                  .previousInvalidTracks),
                                          playlist.uri);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
