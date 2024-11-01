import '../../models/primary models/search_items.dart';
import 'search_spotify_service.dart';

class SearchSpotifyController {
  Future<SearchItems> searchSpotifyContent(
    String query,
    String types,
    String market,
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

      final response = await SearchSpotifyService()
          .searchSpotifyContent(query, types, market, limit, offset);

      if (offset == 0) {
        return SearchItems.fromJson(response.data);
      } else {
        if (mergeItems != null) {
          mergeItems.fromInstance(response.data);
          return mergeItems;
        } else {
          throw Exception('Error at merging search');
        }
      }
    } on Exception {
      rethrow;
    }
  }
}
