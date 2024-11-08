import '../../models/primary models/search_items.dart';
import 'search_spotify_service.dart';

import 'package:flutter/widgets.dart';

enum SearchSpotifyState { idle, success, error, loading }

class SearchSpotifyController {
  var state = ValueNotifier(SearchSpotifyState.idle);

  Future<SearchItems> searchSpotifyContent(
    String query,
    String types,
    String? market,
    int limit,
    int offset, {
    SearchItems? mergeItems,
  }) async {
    try {
      if (types == '{}') {
        types = 'album,artist,playlist,track';
      } else {
        types =
            types.replaceAll('{', '').replaceAll('}', '').replaceAll(' ', '');
      }

      state.value = SearchSpotifyState.loading;

      final response = await SearchSpotifyService()
          .searchSpotifyContent(query, types, market ?? 'us', limit, offset);

      if (offset == 0) {
        state.value = SearchSpotifyState.idle;
        return SearchItems.fromJson(response.data);
      } else {
        if (mergeItems != null) {
          mergeItems.fromInstance(response.data);
          state.value = SearchSpotifyState.idle;
          return mergeItems;
        } else {
          throw Exception('Error at merging search');
        }
      }
    } on Exception {
      state.value = SearchSpotifyState.error;
      rethrow;
    }
  }
}
