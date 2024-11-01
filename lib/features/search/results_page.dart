import '../../models/primary models/search_items.dart';
import '../../models/primary models/user_profile_model.dart';
import '../../shared/widgets/circular_progress.dart';
import '../album/album_page.dart';
import '../player/player_controller.dart';
import '../playlist/playlist_page.dart';
import 'search_spotify_controller.dart';
import 'widgets/album_search_tile.dart';
import 'widgets/artist_search_tile.dart';
import 'widgets/playlist_search_tile.dart';
import 'widgets/track_search_tile.dart';

import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage(
      {super.key, required this.initialSearchData, required this.query});

  final SearchItems initialSearchData;

  final String query;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late SearchItems searchData;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  searchWithFilter(int offset, String types, {SearchItems? dataToMerge}) {
    isLoading.value = true;

    SearchSpotifyController()
        .searchSpotifyContent(
      widget.query,
      types,
      UserProfile.instance.country ?? 'US',
      20,
      offset,
      mergeItems: dataToMerge,
    )
        .then((newData) {
      setState(() {
        searchData = newData;
      });

      isLoading.value = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchData = widget.initialSearchData;
    if (searchData.albumsContainer == null &&
        searchData.artistsContainer == null &&
        searchData.playlistContainer == null &&
        searchData.tracksContainer == null &&
        widget.query.isNotEmpty) {
      searchWithFilter(0, '{}');
    }
  }

  Set<String> selection = {};

  @override
  Widget build(BuildContext context) {
    int albumItemsCount = (searchData.albumsContainer?.items?.length ?? 0);
    int artistItemsCount = (searchData.artistsContainer?.items?.length ?? 0);
    int playlistItemsCount = (searchData.playlistContainer?.items?.length ?? 0);
    int trackItemsCount = (searchData.tracksContainer?.items?.length ?? 0);

    int allItemsCount = albumItemsCount +
        artistItemsCount +
        playlistItemsCount +
        trackItemsCount;

    if (allItemsCount == 0 && !isLoading.value) {
      return const Center(child: Text('No results found.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton<String>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: <ButtonSegment<String>>[
              const ButtonSegment(value: 'album', label: Text('Album')),
              const ButtonSegment(value: 'artist', label: Text('Artist')),
              const ButtonSegment(value: 'playlist', label: Text('Playlist')),
              const ButtonSegment(value: 'track', label: Text('Track')),
            ],
            selected: selection,
            onSelectionChanged: (Set<String> newSelection) {
              if (mounted) {
                setState(
                  () {
                    selection = newSelection;
                    searchWithFilter(0, selection.toString());
                  },
                );
              }
            },
          ),
        ),
        (isLoading.value)
            ? const Center(
                child: SizedBox(
                  width: 40,
                  height: 80,
                  child: CircularProgress(isDone: false),
                ),
              )
            : Expanded(
                child: Scrollbar(
                  child: ListenableBuilder(
                      listenable: PlayerController.instance.playerContext,
                      builder: (context, snapshot) {
                        String contextUri = PlayerController
                                .instance.playerContext.value?.uri ??
                            '';
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: allItemsCount,
                          itemBuilder: (context, index) {
                            if ((index + 1) == allItemsCount &&
                                !isLoading.value &&
                                selection.isNotEmpty) {
                              searchWithFilter(
                                index + 1,
                                selection.toString(),
                                dataToMerge: searchData,
                              );
                            }

                            if ((index + 1) <= albumItemsCount) {
                              return AlbumSearchTile(
                                album:
                                    searchData.albumsContainer!.items![index],
                                isPlaying: contextUri ==
                                    searchData
                                        .albumsContainer!.items![index].uri,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                        initialAlbumData: searchData
                                            .albumsContainer!.items![index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            if ((index + 1) <=
                                albumItemsCount + artistItemsCount) {
                              int localIndex = index - albumItemsCount;
                              return ArtistSearchTile(
                                artist: searchData
                                    .artistsContainer!.items![localIndex],
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
                                playlist: searchData
                                    .playlistContainer!.items![localIndex],
                                isPlaying: contextUri ==
                                    searchData.playlistContainer
                                        ?.items?[localIndex].uri,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistPage(
                                        playlist: searchData.playlistContainer!
                                            .items![localIndex],
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
                                track: searchData
                                    .tracksContainer!.items![localIndex],
                                isPlaying: contextUri ==
                                    searchData.tracksContainer!
                                        .items![localIndex].uri,
                                onTap: () {
                                  PlayerController.instance.play(searchData
                                      .tracksContainer!.items![localIndex].uri);
                                },
                              );
                            }
                            return null;
                          },
                        );
                      }),
                ),
              ),
      ],
    );
  }
}
