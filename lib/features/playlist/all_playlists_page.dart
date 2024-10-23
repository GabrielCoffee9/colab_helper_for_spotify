import '../../models/primary models/user_playlists_model.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import 'widgets/search_playlists.dart';
import 'playlist_controller.dart';
import 'playlist_page.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllPlaylistsPage extends StatefulWidget {
  const AllPlaylistsPage({super.key});

  @override
  State<AllPlaylistsPage> createState() => _AllPlaylistsPageState();
}

class _AllPlaylistsPageState extends State<AllPlaylistsPage> {
  UserPlaylists userPlaylists = UserPlaylists();
  final ScrollController _scrollController = ScrollController();
  PlaylistController playlistController = PlaylistController();

  bool userPlaylistsLoading = true;

  Future<void> getPlaylists({int offset = 0}) async {
    playlistController
        .getCurrentUserPlaylists(limit: 25, offset: offset)
        .then((value) {
      if (mounted) {
        setState(() {
          userPlaylists = value;
          userPlaylistsLoading = false;
        });
      }
    });
    return;
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {});
      }
    });

    getPlaylists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
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
        onRefresh: () => getPlaylists(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: userPlaylistsLoading
              ? const Center(
                  child: Column(
                    children: [
                      LinearProgressIndicator(),
                      Text('Loading'),
                    ],
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: userPlaylists.playlists?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (index + 1 == (userPlaylists.playlists?.length ?? 0) &&
                        ((userPlaylists.total ?? 0) > (index + 1)) &&
                        playlistController.state.value !=
                            PlaylistState.loading) {
                      getPlaylists(offset: index + 1);
                    }

                    if (playlistController.state.value ==
                        PlaylistState.loading) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgress(isDone: false),
                          Text('Loading')
                        ],
                      );
                    }

                    return SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaylistPage(
                                playlist: userPlaylists.playlists![index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              child: SizedBox(
                                height: 162,
                                width: 170,
                                child: CachedNetworkImage(
                                  memCacheWidth: 446,
                                  memCacheHeight: 393,
                                  maxWidthDiskCache: 446,
                                  maxHeightDiskCache: 393,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const EmptyPlaylistCover(),
                                  errorWidget: (context, url, error) =>
                                      const EmptyPlaylistCover(),
                                  imageUrl: userPlaylists.playlists![index]
                                          .images?.first.url ??
                                      '',
                                ),
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
                                          userPlaylists
                                                  .playlists![index].name ??
                                              'Unnamed Playlist',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    userPlaylists.playlists![index].owner
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
                ),
        ),
      ),
    );
  }
}
