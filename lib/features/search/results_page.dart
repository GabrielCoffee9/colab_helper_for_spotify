import '../../models/primary models/search_items.dart';
import '../../models/primary models/user_profile_model.dart';
import '../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../shared/widgets/circular_progress.dart';
import '../album/album_page.dart';
import '../artist/artist_page.dart';
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
  SearchSpotifyController searchSpotifyController = SearchSpotifyController();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  late bool isResultsLoading;

  int albumItemsCount = 0;
  int artistItemsCount = 0;
  int playlistItemsCount = 0;
  int trackItemsCount = 0;
  int allItemsCount = 0;

  searchWithFilter(int offset, String types, {SearchItems? dataToMerge}) {
    searchSpotifyController
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

        isResultsLoading = false;
      });
    });
  }

  void updateItemsCounts() {
    setState(() {
      albumItemsCount = (searchData.albumsContainer?.items?.length ?? 0);
      artistItemsCount = (searchData.artistsContainer?.items?.length ?? 0);
      playlistItemsCount = (searchData.playlistContainer?.items?.length ?? 0);
      trackItemsCount = (searchData.tracksContainer?.items?.length ?? 0);

      allItemsCount = albumItemsCount +
          artistItemsCount +
          playlistItemsCount +
          trackItemsCount;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    searchData = widget.initialSearchData;
    updateItemsCounts();

    if (allItemsCount == 0) {
      isResultsLoading = true;
    } else {
      isResultsLoading = false;
    }

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
    updateItemsCounts();
    if (allItemsCount == 0 && !isResultsLoading) {
      return Center(
          child: Text(LocalizationsController.of(context)!.noResultsFound));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton<String>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: <ButtonSegment<String>>[
              ButtonSegment(
                  value: 'album',
                  label: Text(LocalizationsController.of(context)!.album)),
              ButtonSegment(
                  value: 'artist',
                  label: Text(LocalizationsController.of(context)!.artist)),
              const ButtonSegment(value: 'playlist', label: Text('Playlist')),
              ButtonSegment(
                  value: 'track',
                  label: Text(LocalizationsController.of(context)!.track)),
            ],
            selected: selection,
            onSelectionChanged: (Set<String> newSelection) {
              if (!isResultsLoading) {
                setState(
                  () {
                    selection = newSelection;
                    _scrollController.animateTo(
                        _scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn);
                    searchWithFilter(0, selection.toString());
                  },
                );
              }
            },
          ),
        ),
        (isResultsLoading)
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
                                searchSpotifyController.state.value !=
                                    SearchSpotifyState.loading &&
                                selection.isNotEmpty) {
                              searchWithFilter(
                                index + 1,
                                selection.toString(),
                                dataToMerge: searchData,
                              );
                            }

                            if ((index + 1) >= allItemsCount &&
                                searchSpotifyController.state.value ==
                                    SearchSpotifyState.loading &&
                                selection.isNotEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const LinearProgressIndicator(),
                                  Text(LocalizationsController.of(context)!
                                      .loading)
                                ],
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
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ArtistPage(
                                        initialArtistData: searchData
                                            .artistsContainer!
                                            .items![localIndex],
                                      ),
                                    ),
                                  );
                                },
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
                                        initialPlaylistData: searchData
                                            .playlistContainer!
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
