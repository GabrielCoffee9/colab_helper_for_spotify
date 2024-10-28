import 'package:colab_helper_for_spotify/features/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_profile_model.dart';
import 'package:flutter/material.dart';

class SearchPlaylists extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search Playlists';

  @override
  set query(String value) {
    // PlaylistController()
    //     .searchPlaylists(value, UserProfile.instance.country ?? 'US', 0);
    super.query = value;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
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
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
