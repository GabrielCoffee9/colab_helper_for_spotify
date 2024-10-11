import '../../models/secundary models/playlist_model.dart';
import '../../models/secundary models/track_model.dart';
import '../../shared/modules/user/user_controller.dart';
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
    required this.playlist,
  });

  final Playlist playlist;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  PlaylistController playlistController = PlaylistController();
  PlayerController playerController = PlayerController.instance;

  UserController userController = UserController();

  final ScrollController _scrollController = ScrollController();

  Playlist playlist = Playlist();
  ValueNotifier<bool> playlistLoading = ValueNotifier(true);

  String selectedSongUri = "";

  bool isPaused = false;

  bool upPage = false;

  String? urlOwnerPlaylist;

  Future<void> getTracks({int offset = 0}) async {
    playlistController.getPlaylistTracks(playlist, offset).then((value) {
      if (mounted) {
        setState(() {
          playlist = value;
          playlistLoading.value = false;
        });
      }
    });

    return;
  }

  void getOwnerPlaylist(userId) {
    userController.getUserUrlProfileImage(userId).then((value) {
      setState(() {
        urlOwnerPlaylist = value;
      });
    });
  }

  @override
  void initState() {
    playlist = widget.playlist;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300) {
        if (!upPage) {
          setState(() {
            upPage = true;
          });
        }
      } else {
        setState(() {
          upPage = false;
        });
      }
    });

    playerController.getPlayerState().then((data) {
      if (mounted) {
        setState(() {
          selectedSongUri = data?.track?.uri ?? '';
          isPaused = data?.isPaused ?? true;
        });
      }
    });

    playerController.playerState.listen((data) {
      if (mounted) {
        setState(() {
          selectedSongUri = data.track?.uri ?? '';
          isPaused = data.isPaused;
        });
      }
    });

    getTracks();
    getOwnerPlaylist(playlist.owner!.id);
    super.initState();
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
      floatingActionButton: upPage
          ? FloatingActionButton(
              mini: true,
              child: Icon(Icons.keyboard_double_arrow_up),
              onPressed: () {
                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastOutSlowIn);
              })
          : null,
      appBar: AppBar(
        primary: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: colors.surface,
                    title: const Text('Edit playlist details'),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                      TextButton(onPressed: () {}, child: const Text('Save'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => getTracks(),
        child: (playlistLoading.value)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading')
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
                                fit: BoxFit.cover,
                                imageUrl: playlist.images?.first.url! ?? '',
                                memCacheWidth: 480,
                                memCacheHeight: 350,
                                maxWidthDiskCache: 480,
                                maxHeightDiskCache: 350,
                                placeholder: (context, url) =>
                                    const EmptyPlaylistCover(),
                                errorWidget: (context, url, error) =>
                                    const EmptyPlaylistCover()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlistLoading.value
                                      ? ''
                                      : playlist.name ?? 'Unnamed Playlist',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: colors.onSurface,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: [
                                      (playlist.owner?.id != 'spotify')
                                          ? SizedBox(
                                              width: 60,
                                              child: ProfilePicture(
                                                imageUrl:
                                                    urlOwnerPlaylist ?? '',
                                                avatar: true,
                                              ),
                                            )
                                          : Image.asset(
                                              'lib/assets/Spotify_Icon_RGB_Green.png',
                                              height: 60,
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(playlist.owner?.displayName ??
                                                ''),
                                            Text(
                                              "Creator",
                                              style: TextStyle(
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
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
                          child: (playlist.tracks?.isNotEmpty ?? false)
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
                          final Track item =
                              playlist.tracks!.removeAt(oldIndex);
                          playlist.tracks!.insert(newIndex, item);
                        });
                      },
                      itemCount: playlist.tracks?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (index + 1 == (playlist.tracks?.length ?? 0) &&
                            (playlist.hasMoreToLoad) &&
                            playlistController.state.value !=
                                PlaylistState.loading) {
                          getTracks(offset: index + 1);
                        }

                        if (playlistController.state.value ==
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
                          padding: const EdgeInsets.only(left: 8, right: 8),
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
                                songName: playlist.tracks![index].name,
                                artist: playlist.tracks?[index].allArtists,
                                imageUrl: playlist.tracks![index].album!.images!
                                        .isNotEmpty
                                    ? playlist
                                        .tracks![index].album!.images!.first.url
                                    : '',
                                selected: selectedSongUri ==
                                    playlist.tracks?[index].uri,
                                playingNow: (selectedSongUri ==
                                        playlist.tracks?[index].uri) &&
                                    !isPaused,
                                onTap: () {
                                  setState(() {
                                    if (selectedSongUri ==
                                        playlist.tracks?[index].uri) {
                                      isPaused
                                          ? playerController.resume()
                                          : playerController.pause();
                                    } else {
                                      playerController.playIndexPlaylist(
                                          index, playlist.uri);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
