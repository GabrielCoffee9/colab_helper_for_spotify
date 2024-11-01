import '../../../models/secundary models/playlist_model.dart';
import '../../../models/primary models/user_playlists_model.dart';
import '../../player/player_controller.dart';
import '../../search/widgets/playlist_search_tile.dart';
import '../playlist_controller.dart';
import '../playlist_page.dart';

import 'package:flutter/material.dart';

class SearchPlaylistsPage extends SearchDelegate {
  final UserPlaylists initialPlaylists;

  ValueNotifier<UserPlaylists> searchData = ValueNotifier(UserPlaylists());

  bool isloadingData = false;

  SearchPlaylistsPage(this.initialPlaylists) {
    searchData.value = initialPlaylists;
    searchPlaylists();
  }

  searchPlaylists() {
    if (!isloadingData &&
        (searchData.value.total! > searchData.value.playlists.length)) {
      isloadingData = true;
      PlaylistController()
          .getCurrentUserPlaylists(
              limit: 25,
              offset: searchData.value.playlists.length,
              currentUserPlaylists: searchData.value)
          .then((value) {
        searchData.value = value;
        isloadingData = false;
        searchPlaylists();
      });
    }
  }

  @override
  String? get searchFieldLabel => 'Search Your Playlists';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query = '',
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
  Widget buildResults(BuildContext context) => buildPlaylistsSuggestions();

  @override
  Widget buildSuggestions(BuildContext context) => buildPlaylistsSuggestions();

  Widget buildPlaylistsSuggestions() {
    if (query.isNotEmpty) {
      List<Playlist> searchPlaylistItems = [];

      for (var element in searchData.value.playlists) {
        if ((element.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (element.owner?.displayName
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)) {
          searchPlaylistItems.add(element);
        }
      }

      return ListView.builder(
        itemCount: searchPlaylistItems.length,
        itemBuilder: (context, index) {
          String contextUri =
              PlayerController.instance.playerContext.value?.uri ?? '';
          return PlaylistSearchTile(
            playlist: searchPlaylistItems[index],
            isPlaying: contextUri == searchPlaylistItems[index].uri,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaylistPage(
                    playlist: searchPlaylistItems[index],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return const Center(child: Text('Type to search'));
  }
}
