import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
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
  PlaylistService playlistService = PlaylistService();

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Playlist')),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          FutureBuilder(
              future: playlistService.getPlaylistTracks(widget.playlist, 0),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            snapshot.data!.haveImage
                                ? InteractiveViewer(
                                    child: FadeInImage.memoryNetwork(
                                      height: screenSize.height / 4,
                                      placeholder: kTransparentImage,
                                      image: snapshot.data!.images!.first.url ??
                                          '',
                                    ),
                                  )
                                : Container(
                                    height: screenSize.height / 4,
                                    width: screenSize.width / 2.5,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                            Text(
                              snapshot.data!.name ?? 'Unnamed Playlist',
                              style: const TextStyle(
                                  fontSize: 24,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        snapshot.data!.tracks!.isEmpty
                            ? SizedBox(
                                height: screenSize.height / 2,
                                width: screenSize.width,
                                child: Center(
                                  child: Text(
                                    'Empty Playlist !!!',
                                    style: TextStyle(
                                        fontSize: 24, color: colors.primary),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.tracks!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    selected: index == selectedIndex,
                                    selectedColor: colors.primary,
                                    contentPadding: const EdgeInsets.all(8),
                                    title: Text(
                                        snapshot.data!.tracks![index].name ??
                                            'Error'),
                                    subtitle: Text(snapshot.data!.tracks![index]
                                            .artists!.first.name ??
                                        'artist'),
                                    leading: snapshot.data!.tracks![index]
                                            .album!.images!.isNotEmpty
                                        ? FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: snapshot.data!.tracks![index]
                                                    .album!.images!.first.url ??
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
                                      await PlaylistService().playSong(snapshot
                                              .data!.tracks![index].uri ??
                                          widget.playlist.tracks![index].uri);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 6),
                              )
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    children: const [
                      LinearProgressIndicator(),
                      Text('Loading'),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
