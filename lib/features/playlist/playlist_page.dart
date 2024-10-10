import '../../models/secundary models/playlist_model.dart';
import '../../models/secundary models/track_model.dart';
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
  final ScrollController _scrollController = ScrollController();

  Playlist playlist = Playlist();
  ValueNotifier<bool> playlistLoading = ValueNotifier(true);

  String selectedSongUri = "";

  bool isPaused = false;

  Future<void> getPlaylists({int offset = 0}) async {
    playlistLoading.value = true;

    playlistController.getPlaylistTracks(playlist, offset).then((value) {
      playlist = value;

      if (mounted) {
        setState(() {});
      }

      playlistLoading.value = false;
    });

    return;
  }

  @override
  void initState() {
    playlist = widget.playlist;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          mounted) {
        setState(() {});
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

    getPlaylists();
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
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn);
          },
          child: Text(
            playlistLoading.value ? '' : playlist.name ?? 'Unnamed Playlist',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              color: colors.onSurface,
            ),
          ),
        ),
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
        onRefresh: () => getPlaylists(),
        child: playlist.tracks?.isEmpty ?? true && playlistLoading.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 170,
                            height: 120,
                            child: CachedNetworkImage(
                              imageUrl: playlist.images?.first.url! ?? '',
                              memCacheWidth: 446,
                              memCacheHeight: 315,
                              maxWidthDiskCache: 446,
                              maxHeightDiskCache: 315,
                              placeholder: (context, url) =>
                                  Container(color: Colors.transparent),
                              errorWidget: (context, url, error) => Container(
                                width: 170,
                                height: 170,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox.square(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 12, right: 12),
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
                        final Track item = playlist.tracks!.removeAt(oldIndex);
                        playlist.tracks!.insert(newIndex, item);
                      });
                    },
                    itemCount: playlist.tracks?.length ?? 0,
                    itemBuilder: (context, index) {
                      if ((index + 20) == playlist.tracks?.length &&
                          playlist.hasMoreToLoad &&
                          !playlistLoading.value &&
                          mounted) {
                        getPlaylists(offset: index + 20);
                      }

                      return Padding(
                        key: Key('$index'),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          key: Key('$index'),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: colors.outline, width: 0.5),
                            ),
                          ),
                          child: ReorderableDelayedDragStartListener(
                            enabled: false,
                            index: index,
                            child: SongTile(
                              key: Key('$index'),
                              songName: playlist.tracks![index].name,
                              artist: playlist.tracks?[index].allArtists,
                              imageUrl: playlist
                                      .tracks![index].album!.images!.isNotEmpty
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
                ],
              ),
      ),
    );
  }
}
