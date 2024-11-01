import '../../models/secundary models/album_model.dart';
import 'album_service.dart';

import 'package:flutter/widgets.dart';

enum AlbumState { idle, success, error, loading }

class AlbumController {
  var state = ValueNotifier(AlbumState.idle);

  String? lastError;
  Future<Album> getAlbum(
    Album album,
    String? market,
    int offset,
  ) async {
    try {
      state.value = AlbumState.loading;

      final albumInformationResponse =
          await AlbumService().getAlbumInformation(album.id!, market ?? 'us');
      albumInformationResponse.data['tracks'] = null;

      album.fromInstance(albumInformationResponse.data);

      final albumTracksResponse = await AlbumService()
          .getAlbumTracks(album.id!, market ?? 'us', offset);

      album.fromInstance(albumTracksResponse.data);

      if (album.artists.isNotEmpty) {
        final artistResponse =
            await AlbumService().getArtist(album.artists.first.id!);
        album.artists.first.fromInstance(artistResponse.data);
      }

      state.value = AlbumState.idle;
      return album;
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = AlbumState.error;
      return Album();
    }
  }
}
