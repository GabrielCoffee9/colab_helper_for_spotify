import '../../../models/secundary models/playlist_model.dart';
import '../../../models/primary models/user_playlists_model.dart';
import '../../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../player/player_controller.dart';
import '../../search/widgets/playlist_search_tile.dart';
import '../playlist_controller.dart';
import '../playlist_page.dart';

import 'package:flutter/material.dart';

class SearchPlaylistsPage extends SearchDelegate {
  final UserPlaylists initialPlaylists;

  UserPlaylists searchData = UserPlaylists();

  bool dataIsLoading = false;

  SearchPlaylistsPage(this.initialPlaylists, this.localizedSearchFieldLabel) {
    searchData = initialPlaylists;
    searchPlaylists();
  }

  String localizedSearchFieldLabel;

  searchPlaylists() {
    if (!dataIsLoading && (searchData.total! > searchData.playlists.length)) {
      dataIsLoading = true;
      PlaylistController()
          .getCurrentUserPlaylists(
        limit: 25,
        offset: searchData.playlists.length,
        currentUserPlaylists: searchData,
      )
          .then((value) {
        searchData = value;
        dataIsLoading = false;
        searchPlaylists();
      });
    }
  }

  @override
  String? get searchFieldLabel => localizedSearchFieldLabel;

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
  Widget buildResults(BuildContext context) =>
      buildPlaylistsSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) =>
      buildPlaylistsSuggestions(context);

  Widget buildPlaylistsSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      List<Playlist> searchPlaylistItems = [];

      for (var element in searchData.playlists) {
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
                    initialPlaylistData: searchPlaylistItems[index],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Center(
        child: Text(LocalizationsController.of(context)!.typeToSearch));
  }
}
