import 'package:colab_helper_for_spotify/features/playlist/playlist_page.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/widgets/colab_playlist_card.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class AllPlaylistsPage extends StatefulWidget {
  const AllPlaylistsPage({super.key, required this.userPlaylists});

  final Future<UserPlaylists> userPlaylists;

  @override
  State<AllPlaylistsPage> createState() => _AllPlaylistsPageState();
}

class _AllPlaylistsPageState extends State<AllPlaylistsPage> {
  late final Future<UserPlaylists> userPlaylists;
  PlaylistController playlistController = PlaylistController();

  @override
  void initState() {
    playlistController.clearPlaylistsMemory();
    userPlaylists =
        playlistController.getCurrentUserPlaylists(limit: 50, offset: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('All Playlists'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: userPlaylists,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    // padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.playlists?.length ?? 0,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlaylistPage(
                                  playlist: snapshot.data!.playlists![index],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: snapshot.data!.playlists![index].images!
                                        .isNotEmpty
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: FadeInImage.memoryNetwork(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          fit: BoxFit.fill,
                                          placeholder: kTransparentImage,
                                          image: snapshot
                                                  .data!
                                                  .playlists![index]
                                                  .images!
                                                  .first
                                                  .url ??
                                              '',
                                        ),
                                      )
                                    : EmptyPlaylistCover(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        size: 60,
                                      ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.playlists![index]
                                                    .name ??
                                                'Unnamed Playlist',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        snapshot.data!.playlists![index].owner
                                                ?.displayName ??
                                            'Unknown',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // child: ColabPlaylistCard(
                        //   onTap: () async {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => PlaylistPage(
                        //           playlist: snapshot.data!.playlists![index],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   playlistName:
                        //       '${snapshot.data!.playlists![index].name}',
                        //   urlImage: snapshot
                        //           .data!.playlists![index].images!.isNotEmpty
                        //       ? snapshot
                        //           .data!.playlists![index].images!.first.url
                        //       : null,
                        // ),
                      );
                    },
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
              },
            ),
          ),
        ],
      ),
    );
  }
}