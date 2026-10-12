// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get syncAccount => 'Sync account';

  @override
  String get yourPlaylists => 'Your Playlists';

  @override
  String get language => 'Languages';

  @override
  String get system => 'System';

  @override
  String get english => 'English';

  @override
  String get portugueseBrazilian => 'Portuguese Brazilian';

  @override
  String get settings => 'Settings';

  @override
  String get viewAll => 'View all';

  @override
  String get allPlaylists => 'All Playlists';

  @override
  String get unnamedPlaylist => 'Unnamed Playlist';

  @override
  String get unnamedAlbum => 'Unnamed album';

  @override
  String get unavailableSong => 'Unavailable song';

  @override
  String get unknown => 'Unknown';

  @override
  String nSongs(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString songs',
      one: '1 song',
      zero: 'no songs',
    );
    return '$_temp0';
  }

  @override
  String get searchYourPlaylists => 'Search Your Playlists';

  @override
  String get typeToSearch => 'Type to search';

  @override
  String get errorLoadingSearch => 'Error loading searching, please try again.';

  @override
  String get noResultsFound => 'No results found.';

  @override
  String get emptyPlaylist => 'Empty Playlist !!!';

  @override
  String get errorReorder =>
      'Error when trying to reorder the track, please try again.';

  @override
  String get album => 'Album';

  @override
  String get artist => 'Artist';

  @override
  String get track => 'Track';

  @override
  String albumType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'single': 'Single',
        'album': 'Album',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get followers => 'Followers';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get topSongs => 'Top songs';

  @override
  String get albums => 'Albums';

  @override
  String get loadMoreAlbums => 'Load more albums';

  @override
  String get likedSongs => 'Liked Songs';

  @override
  String get queue => 'Queue';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get nextFrom => 'Next from:';

  @override
  String get yourDevices => 'Your devices';

  @override
  String get onStandby => 'On standby';

  @override
  String get currentDevice => 'Current device';

  @override
  String get visualizationOnly => 'Visualization only';

  @override
  String get noCompatibleDevices => 'No compatible devices were found';

  @override
  String get latestRelease => 'Latest Release';

  @override
  String get enjoyThisFeature => 'Enjoy this feature on Spotify premium';

  @override
  String get colabFollowsPlansRules =>
      'Colab Helper follows Spotify plans rules.';

  @override
  String get thisActionIsPremium =>
      'This action is only available for Spotify premium users.';

  @override
  String get spotifyPremiumLets =>
      'Spotify Premium lets you play any track, podcast episode or audiobook, ad-free and with better audio quality. Go to ';

  @override
  String get toTryit => ' to try it for free.';

  @override
  String get syncLost => 'Spotify sync connection was lost';

  @override
  String get syncPlsWait => 'Syncing to Spotify, please wait.';

  @override
  String get errorCheckConnection =>
      'Error! Check your connection and try again later.';

  @override
  String get errorCrash =>
      'If you are seeing this screen, your app/page crashed 😥';

  @override
  String get spotifyNotInstalled =>
      'Your device doesn\'t have the Spotify app installed';

  @override
  String get colabHelperUsesSpotify =>
      'Colab Helper uses the Spotify app to sync and play tracks, please install Spotify before use this app.';

  @override
  String get getSpotifyFree => 'GET SPOTIFY FREE';

  @override
  String userType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'premium': 'Premium',
        'free': 'Free',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get editPlaylist => 'Edit playlist';

  @override
  String get errorTryingToLoadImage =>
      'Error trying to load image, please select another image.';

  @override
  String get changeImage => 'Change Image';

  @override
  String get chooseFromCamera => 'Choose from camera';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get imageTooBig =>
      'The selected Image is too big. please select another image.';

  @override
  String get imageUploadWarningOne =>
      'By proceeding, you agree to give Spotify access to the image you choose to upload.';

  @override
  String get imageUploadWarningTwo =>
      'Please make sure you have the right to upload the image.';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get cancelChanges => 'Cancel changes';

  @override
  String get discardChangesConfirmation =>
      'Are you sure you want to discard all the changes you made ?';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get save => 'Save';

  @override
  String get sometimesTakesTime =>
      'Sometimes when saving playlist details, changes may take up to 1 minute to update on the page. You can manually refresh the playlist by pulling down to refresh.';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';
}
