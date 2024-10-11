import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class AuthService {
  final String _appClientId = const String.fromEnvironment('appClientId');
  final String _appRedirectURI = const String.fromEnvironment('appRedirectURI');

  final String _scope = 'ugc-image-upload,'
      'user-modify-playback-state,'
      'user-read-playback-state,'
      'user-read-currently-playing,'
      'user-follow-modify,'
      'user-follow-read,'
      'user-read-recently-played,'
      'user-read-playback-position,'
      'user-top-read,'
      'playlist-read-collaborative,'
      'playlist-modify-public,'
      'playlist-read-private,'
      'playlist-modify-private,'
      'app-remote-control,'
      'user-read-email,'
      'user-read-private,'
      'user-library-modify,'
      'user-library-read';

  /// Get a new access token and connects to spotify remote client.
  ///
  /// Returns the access token as [String] if succesful.
  Future<String> getNewTokenAndConnectToSpotifyRemote() async {
    try {
      String token;

      token = await SpotifySdk.getAccessToken(
        clientId: _appClientId,
        redirectUrl: _appRedirectURI,
        scope: _scope,
      );

      await connectSpotifyRemote(token);

      var storage = const FlutterSecureStorage();

      await storage.write(key: 'accessToken', value: token);
      await storage.write(
          key: 'accessTokenDate',
          value: DateTime.now().millisecondsSinceEpoch.toString());

      return token;
    } on Exception {
      rethrow;
    }
  }

  connectSpotifyRemote(String? token) async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
        clientId: _appClientId,
        redirectUrl: _appRedirectURI,
        accessToken: token,
      );
    } on Exception {
      rethrow;
    }
  }
}
