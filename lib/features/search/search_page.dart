import '../../../models/primary models/search_items.dart';
import '../../../models/primary models/user_profile_model.dart';
import '../../../shared/widgets/circular_progress.dart';
import '../album/album_page.dart';
import '../player/player_controller.dart';
import '../playlist/playlist_page.dart';
import 'search_spotify_controller.dart';
import 'widgets/album_search_tile.dart';
import 'widgets/artist_search_tile.dart';
import 'widgets/playlist_search_tile.dart';
import 'widgets/track_search_tile.dart';
import 'results_page.dart';

import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate {
  SearchItems searchData = SearchItems();

  Future<SearchItems> searchSuggestions() async {
    searchData = SearchItems();
    return await SearchSpotifyController().searchSpotifyContent(
      query,
      '{}',
      UserProfile.instance.country ?? 'US',
      5,
      0,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => ResultsPage(
        initialSearchData: searchData,
        query: query,
      );

  @override
  Widget buildSuggestions(BuildContext context) => searchPlaylists(context);

  Widget searchPlaylists(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder(
        future: searchSuggestions(),
        builder: (context, AsyncSnapshot<SearchItems> searchSnapshot) {
          if (searchSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                child: CircularProgress(isDone: false),
              ),
            );
          } else if (searchSnapshot.hasError || searchSnapshot.data == null) {
            return const Center(child: Text('Error loading searching.'));
          }

          searchData = searchSnapshot.data!;
          int albumItemsCount =
              (searchData.albumsContainer?.items?.length ?? 0);
          int artistItemsCount =
              (searchData.artistsContainer?.items?.length ?? 0);
          int playlistItemsCount =
              (searchData.playlistContainer?.items?.length ?? 0);
          int trackItemsCount =
              (searchData.tracksContainer?.items?.length ?? 0);

          int allItemsCount = albumItemsCount +
              artistItemsCount +
              playlistItemsCount +
              trackItemsCount;

          if (allItemsCount == 0) {
            return const Center(child: Text('No results found.'));
          }

          return ListenableBuilder(
              listenable: PlayerController.instance.playerContext,
              builder: (context, snapshot) {
                String contextUri =
                    PlayerController.instance.playerContext.value?.uri ?? '';
                return ListView.builder(
                  itemCount: allItemsCount,
                  itemBuilder: (context, index) {
                    if ((index + 1) <= albumItemsCount) {
                      return AlbumSearchTile(
                        album: searchData.albumsContainer!.items![index],
                        isPlaying: contextUri ==
                            searchData.albumsContainer!.items![index].uri,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AlbumPage(
                                initialAlbumData:
                                    searchData.albumsContainer!.items![index],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if ((index + 1) <= albumItemsCount + artistItemsCount) {
                      int localIndex = index - albumItemsCount;
                      return ArtistSearchTile(
                        artist: searchData.artistsContainer!.items![localIndex],
                        onTap: () {},
                      );
                    }

                    if ((index + 1) <=
                        albumItemsCount +
                            artistItemsCount +
                            playlistItemsCount) {
                      int localIndex =
                          index - (albumItemsCount + artistItemsCount);
                      return PlaylistSearchTile(
                        playlist:
                            searchData.playlistContainer!.items![localIndex],
                        isPlaying: contextUri ==
                            searchData
                                .playlistContainer?.items?[localIndex].uri,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaylistPage(
                                playlist: searchData
                                    .playlistContainer!.items![localIndex],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if ((index + 1) <= allItemsCount) {
                      int localIndex = index -
                          (albumItemsCount +
                              artistItemsCount +
                              playlistItemsCount);
                      return TrackSearchTile(
                        track: searchData.tracksContainer!.items![localIndex],
                        isPlaying: contextUri ==
                            searchData.tracksContainer!.items![localIndex].uri,
                        onTap: () {
                          PlayerController.instance.play(searchData
                              .tracksContainer!.items![localIndex].uri);
                        },
                      );
                    }
                    return null;
                  },
                );
              });
        },
      );
    } else {
      return const Center(child: Text('Type to search'));
    }
  }
}
