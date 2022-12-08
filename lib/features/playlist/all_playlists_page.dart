import 'package:colab_helper_for_spotify/features/playlist/playlist_page.dart';
import 'package:colab_helper_for_spotify/features/playlist/widgets/search_playlists.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class AllPlaylistsPage extends StatefulWidget {
  const AllPlaylistsPage({super.key});

  @override
  State<AllPlaylistsPage> createState() => _AllPlaylistsPageState();
}

class _AllPlaylistsPageState extends State<AllPlaylistsPage> {
  Future<UserPlaylists>? userPlaylists;
  final ScrollController _scrollController = ScrollController();
  PlaylistController playlistController = PlaylistController();

  Future<void> refreshPage() {
    setState(() {
      userPlaylists =
          playlistController.getCurrentUserPlaylists(limit: 25, offset: 0);
    });
    return userPlaylists!;
  }

  void alternateMethod() {
    setState(() {
      testing.value = !testing.value;
    });
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

  ValueNotifier<bool> testing = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchPlaylists());
            },
            icon: const Icon(Icons.search),
          )
        ],
        title: const Text('All Playlists'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshPage(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: userPlaylists,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: snapshot.data!.playlists?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (index + 1 == (snapshot.data!.playlists?.length ?? 0) &&
                        ((snapshot.data!.total ?? 0) > (index + 1)) &&
                        playlistController.state.value !=
                            PlaylistState.loading) {
                      userPlaylists =
                          playlistController.getCurrentUserPlaylists(
                              limit: 25, offset: index + 1);
                    }

                    if (playlistController.state.value ==
                        PlaylistState.loading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          Text('Loading')
                        ],
                      );
                    }

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
                          children: [
                            SizedBox(
                              child: snapshot.data!.playlists![index].images!
                                      .isNotEmpty
                                  ? SizedBox(
                                      height: 150,
                                      width: 170,
                                      child: FadeInImage.memoryNetwork(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        fit: BoxFit.fill,
                                        placeholder: kTransparentImage,
                                        image: snapshot.data!.playlists![index]
                                                .images!.first.url ??
                                            '',
                                      ),
                                    )
                                  : const EmptyPlaylistCover(
                                      height: 150,
                                      width: 170,
                                      size: 60,
                                    ),
                            ),
                            const SizedBox(height: 2),
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
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
      ),
    );
  }
}
