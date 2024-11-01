import '../secundary models/search_albums_container_model.dart';
import '../secundary models/search_artists_container_model.dart';
import '../secundary models/search_playlists_container_model.dart';
import '../secundary models/search_tracks_container_model.dart';

class SearchItems {
  SearchTracksContainer? tracksContainer;
  SearchArtistsContainer? artistsContainer;
  SearchAlbumsContainer? albumsContainer;
  SearchPlaylistContainer? playlistContainer;

  SearchItems({
    this.tracksContainer,
    this.artistsContainer,
    this.albumsContainer,
    this.playlistContainer,
  });

  SearchItems.fromJson(Map<String, dynamic> json) {
    if (json['tracks'] != null) {
      tracksContainer = SearchTracksContainer.fromJson(json['tracks']);
    }

    if (json['artists'] != null) {
      artistsContainer = SearchArtistsContainer.fromJson(json['artists']);
    }

    if (json['albums'] != null) {
      albumsContainer = SearchAlbumsContainer.fromJson(json['albums']);
    }

    if (json['playlists'] != null) {
      playlistContainer = SearchPlaylistContainer.fromJson(json['playlists']);
    }
  }

  fromInstance(Map<String, dynamic> json) {
    if (json['tracks'] != null && tracksContainer != null) {
      tracksContainer!.fromInstance(json['tracks']);
    }

    if (json['artists'] != null && artistsContainer != null) {
      artistsContainer!.fromInstance(json['artists']);
    }

    if (json['albums'] != null && albumsContainer != null) {
      albumsContainer!.fromInstance(json['albums']);
    }

    if (json['playlists'] != null && playlistContainer != null) {
      playlistContainer!.fromInstance(json['playlists']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    return data;
  }
}
