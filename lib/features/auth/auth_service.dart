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

  Future<String> getToken() async {
    try {
      return await SpotifySdk.getAccessToken(
          clientId: _appClientId, redirectUrl: _appRedirectURI, scope: _scope);
    } on Exception {
      return '';
    }
  }
}
