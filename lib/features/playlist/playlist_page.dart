import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_service.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    super.key,
    required this.playlist,
  });

  // final String playlistId;
  final Playlist playlist;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<Playlist> playlist;
  String playlistName = '';
  PlaylistService playlistService = PlaylistService();
  @override
  void initState() {
    super.initState();

    playlist = Future<Playlist>(() => widget.playlist);
  }

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            initialData: widget.playlist,
            future: playlist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Text('Playlist');
              }
              return const Text('Playlist');
            }),
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: playlist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height / 4,
                            child: Image.network(
                              snapshot.data!.images!.first.url ?? '',
                              frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) =>
                                  child,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                          Text(
                            snapshot.data!.name ??
                                'Unnamed Playlist {known bug}',
                            style: const TextStyle(
                              fontSize: 24,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.tracks!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selected: index == selectedIndex,
                          selectedColor: colors.primary,
                          onTap: () async {
                            setState(() {
                              selectedIndex = index;
                            });
                            await PlaylistService().playSong(
                                snapshot.data!.tracks![index].uri ??
                                    widget.playlist.tracks![index].uri ??
                                    '');
                          },
                          contentPadding: const EdgeInsets.all(8),

                          leading: Image.network(
                              snapshot.data!.tracks![index].album!.images!.first
                                      .url ??
                                  '',
                              frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) =>
                                  child,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                          title: Text(
                              snapshot.data!.tracks![index].name ?? 'Error'),
                          subtitle: Text(snapshot
                                  .data!.tracks![index].artists!.first.name ??
                              'artist'),
                          trailing: index == selectedIndex
                              ? const Icon(
                                  Icons.pause_circle,
                                  size: 40,
                                )
                              : const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 40,
                                ),
                          // title: Text(''),
                        );
                      },
                    )
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      LinearProgressIndicator(),
                      Text('Loading'),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
