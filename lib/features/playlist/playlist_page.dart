import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_service.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
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

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {});
      }
    });

    playlist ??= playlistController.getPlaylistTracks(widget.playlist, 0);

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
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          FutureBuilder(
            future: playlist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverAppBar(
                  pinned: true,
                  expandedHeight: 220,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      snapshot.data!.name ?? 'Unnamed Playlist',
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
                                  image: snapshot.data!.images!.first.url ?? '',
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
                );
              }
              return const SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(''),
                ),
              );
            },
          ),
          FutureBuilder(
            future: playlist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: snapshot.data!.tracks!.length,
                    (context, index) {
                      // if (index == snapshot.data!.tracks!.length + 1 &&
                      //     snapshot.data!.hasMoreToLoad &&
                      //     playlistController.state.value !=
                      //         PlaylistState.loading) {
                      //   if (playlistController.state.value ==
                      //       PlaylistState.loading) {
                      //     return const LinearProgressIndicator();
                      //   }
                      //   return const Center(
                      //       child: Text('No more songs to load'));
                      // }

                      if (index + 1 == snapshot.data!.tracks!.length) {
                        if (snapshot.data!.hasMoreToLoad &&
                            playlistController.state.value !=
                                PlaylistState.loading) {
                          playlist = playlistController.getPlaylistTracks(
                              snapshot.data ?? Playlist(), index + 1);
                        }
                      }

                      return ListTile(
                        selected: index == selectedIndex,
                        selectedColor: colors.primary,
                        contentPadding: const EdgeInsets.all(8),
                        title: snapshot.data!.tracks![index].name?.isNotEmpty ??
                                false
                            ? Text(
                                snapshot.data!.tracks![index].name ?? 'Error')
                            : const Text(
                                'Unavailable song',
                                style: TextStyle(color: Colors.red),
                              ),
                        subtitle: snapshot.data!.tracks![index].artists!.first
                                    .name?.isNotEmpty ??
                                false
                            ? Text(snapshot
                                    .data!.tracks![index].artists!.first.name ??
                                'artist')
                            : const Text('Unknown artist'),
                        leading: snapshot.data!.tracks![index].album!.images
                                    ?.isNotEmpty ??
                                false
                            ? FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data!.tracks![index].album!
                                        .images!.first.url ??
                                    '')
                            : EmptyPlaylistCover(
                                size: 30,
                                height: screenSize.height / 8,
                                width: screenSize.width / 7,
                              ),
                        trailing: index == selectedIndex
                            ? const Icon(
                                Icons.pause_circle,
                                size: 40,
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                                size: 40,
                              ),
                        onTap: () async {
                          setState(() {
                            selectedIndex = index;
                          });
                          await PlaylistService().playSong(
                              snapshot.data!.tracks![index].uri ??
                                  widget.playlist.tracks![index].uri);
                        },
                      );
                    },
                  ),
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: const [
                      LinearProgressIndicator(),
                      Text('Loading'),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
