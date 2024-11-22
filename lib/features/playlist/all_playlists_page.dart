import '../../models/primary models/user_playlists_model.dart';
import '../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import 'widgets/search_playlists_page.dart';
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
  PlaylistController playlistController = PlaylistController();

  bool userPlaylistsIsLoading = true;

  Future<void> getPlaylists({int offset = 0}) async {
    playlistController
        .getCurrentUserPlaylists(
      limit: 25,
      offset: offset,
      currentUserPlaylists: userPlaylists,
    )
        .then((value) {
      if (mounted) {
        setState(() {
          userPlaylists = value;
          userPlaylistsIsLoading = false;
        });
      }
    });

    return;
  }

  @override
  void initState() {
    super.initState();

    getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPlaylistsPage(userPlaylists,
                    LocalizationsController.of(context)!.searchYourPlaylists),
              );
            },
          )
        ],
        title: Text(LocalizationsController.of(context)!.allPlaylists),
      ),
      body: RefreshIndicator(
        onRefresh: () => getPlaylists(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: userPlaylistsIsLoading
              ? Center(
                  child: Column(
                    children: [
                      const LinearProgressIndicator(),
                      Text(LocalizationsController.of(context)!.loading),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: userPlaylists.playlists.length,
                    itemBuilder: (context, index) {
                      bool isLastItem =
                          index + 1 == (userPlaylists.playlists.length);

                      if (isLastItem &&
                          ((userPlaylists.total ?? 0) > (index + 1)) &&
                          playlistController.state.value !=
                              PlaylistState.loading) {
                        getPlaylists(offset: index + 1);
                      }

                      if (isLastItem &&
                          playlistController.state.value ==
                              PlaylistState.loading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgress(isDone: false),
                            Text(LocalizationsController.of(context)!.loading)
                          ],
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaylistPage(
                                initialPlaylistData:
                                    userPlaylists.playlists[index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 162,
                              width: 170,
                              child: CachedNetworkImage(
                                memCacheWidth: 446,
                                memCacheHeight: 393,
                                maxWidthDiskCache: 446,
                                maxHeightDiskCache: 393,
                                placeholder: (context, url) =>
                                    const EmptyPlaylistCover(),
                                errorWidget: (context, url, error) =>
                                    const EmptyPlaylistCover(),
                                imageUrl: userPlaylists.playlists[index].images
                                            ?.isNotEmpty ??
                                        false
                                    ? userPlaylists
                                        .playlists[index].images!.first.url!
                                    : '',
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
                              ),
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
                                          userPlaylists.playlists[index]
                                                  .isUserSavedTracksPlaylist
                                              ? LocalizationsController.of(
                                                      context)!
                                                  .likedSongs
                                              : userPlaylists
                                                      .playlists[index].name ??
                                                  LocalizationsController.of(
                                                          context)!
                                                      .unnamedPlaylist,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    userPlaylists.playlists[index].owner
                                            ?.displayName ??
                                        LocalizationsController.of(context)!
                                            .unknown,
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
