import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
import 'package:colab_helper_for_spotify/models/secundary%20models/track_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_service.dart';
import 'package:colab_helper_for_spotify/shared/widgets/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
  Future<Playlist>? playlist;
  final ScrollController _scrollController = ScrollController();

  int? selectedIndex;

  Future<void> refreshPage() {
    setState(() {
      playlist = playlistController.getPlaylistTracks(widget.playlist, 0);
    });
    return playlist!;
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {});
      }
    });

    refreshPage();
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

    return FutureBuilder(
      future: playlist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.data?.tracks?.isEmpty ?? true)) {
          return Scaffold(
            backgroundColor: colors.background,
            body: RefreshIndicator(
                onRefresh: () => refreshPage(),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 220,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          snapshot.data?.name ?? 'Unnamed playlist',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            color: colors.onSurface,
                          ),
                        ),
                        background: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Column(
                            children: [
                              snapshot.data!.haveImage
                                  ? FadeInImage.memoryNetwork(
                                      width: 170,
                                      height: 120,
                                      placeholder: kTransparentImage,
                                      image: snapshot.data!.images!.first.url ??
                                          '',
                                    )
                                  : Container(
                                      height: 170,
                                      width: 170,
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.music_note_outlined,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Column(
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
                    )
                  ],
                )),
          );
        }

        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: colors.background,
            body: RefreshIndicator(
              onRefresh: () => refreshPage(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      )
                    ],
                    pinned: true,
                    expandedHeight: 220,
                    flexibleSpace: FlexibleSpaceBar(
                      title: GestureDetector(
                        onDoubleTap: () {
                          _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.fastOutSlowIn);
                        },
                        child: Text(
                          snapshot.data!.name ?? 'Unnamed Playlist',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      background: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Column(
                          children: [
                            snapshot.data!.haveImage
                                ? FadeInImage.memoryNetwork(
                                    width: 170,
                                    height: 120,
                                    placeholder: kTransparentImage,
                                    image:
                                        snapshot.data!.images!.first.url ?? '',
                                  )
                                : Container(
                                    height: 170,
                                    width: 170,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox.square(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 12, right: 12),
                        child: Wrap(
                          children: [
                            Text(
                              snapshot.data?.description ?? '',
                              style: TextStyle(color: colors.onSurfaceVariant),
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
                            snapshot.data!.tracks!.removeAt(oldIndex);
                        snapshot.data!.tracks!.insert(newIndex, item);
                      });
                    },
                    itemCount: snapshot.data!.tracks!.length,
                    itemBuilder: (context, index) {
                      if (index + 1 == snapshot.data!.tracks!.length) {
                        if (snapshot.data!.hasMoreToLoad &&
                            playlistController.state.value !=
                                PlaylistState.loading) {
                          playlist = playlistController.getPlaylistTracks(
                              snapshot.data ?? Playlist(), index + 1);
                        }
                      }

                      if (index + 1 == snapshot.data!.tracks!.length &&
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
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          key: Key('$index'),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: colors.outline, width: 0.5))),
                          child: ReorderableDragStartListener(
                            index: index,
                            child: SongTile(
                              key: Key('$index'),
                              songName: snapshot.data!.tracks![index].name,
                              artist: snapshot.data!.tracks![index].allArtists,
                              imageUrl: snapshot.data!.tracks![index].album!
                                      .images!.isNotEmpty
                                  ? snapshot.data!.tracks![index].album!.images!
                                      .first.url
                                  : '',
                              playingNow: index == selectedIndex,
                              onTap: () async {
                                setState(() {
                                  selectedIndex = index;
                                });
                                await PlaylistService().playSong(
                                    snapshot.data!.tracks![index].uri ??
                                        widget.playlist.tracks![index].uri);
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
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            title: const Text('Loading..'),
          ),
          body: Column(
            children: const [
              LinearProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
