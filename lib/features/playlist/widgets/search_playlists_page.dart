import '../../../models/primary models/search_items.dart';
import '../../../models/primary models/user_profile_model.dart';
import '../../../shared/widgets/circular_progress.dart';
import '../playlist_controller.dart';

import 'package:flutter/material.dart';

class SearchPlaylistsPage extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search Playlists';

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
  Widget buildResults(BuildContext context) => searchPlaylists();

  @override
  Widget buildSuggestions(BuildContext context) => searchPlaylists();

  Widget searchPlaylists() {
    if (query.isNotEmpty) {
      return FutureBuilder(
        future: PlaylistController()
            .searchPlaylists(query, UserProfile.instance.country ?? 'US', 0),
        builder: (context, AsyncSnapshot<SearchItems> searchSnapshot) {
          if (searchSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                child: CircularProgress(isDone: false),
              ),
            );
          } else if (searchSnapshot.hasError) {
            return const Center(child: Text('Error loading searching.'));
          } else if (searchSnapshot.data?.playlistContainer?.items?.isEmpty ??
              true) {
            return const Center(child: Text('No results found.'));
          }

          final searchPlaylistItems =
              searchSnapshot.data?.playlistContainer?.items;

          return ListView.builder(
            itemCount: searchPlaylistItems?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(searchPlaylistItems?[index].name ?? 'Loading...'),
                subtitle:
                    Text(searchPlaylistItems?[index].owner?.displayName ?? ''),
                onTap: () {},
              );
            },
          );
        },
      );
    }

    return const Center(child: Text('Type to search'));
  }
}
