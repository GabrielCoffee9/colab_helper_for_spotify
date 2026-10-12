import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Auth sync account button text
  ///
  /// In en, this message translates to:
  /// **'Sync account'**
  String get syncAccount;

  /// No description provided for @yourPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Your Playlists'**
  String get yourPlaylists;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get language;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @portugueseBrazilian.
  ///
  /// In en, this message translates to:
  /// **'Portuguese Brazilian'**
  String get portugueseBrazilian;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @allPlaylists.
  ///
  /// In en, this message translates to:
  /// **'All Playlists'**
  String get allPlaylists;

  /// No description provided for @unnamedPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Playlist'**
  String get unnamedPlaylist;

  /// No description provided for @unnamedAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unnamed album'**
  String get unnamedAlbum;

  /// No description provided for @unavailableSong.
  ///
  /// In en, this message translates to:
  /// **'Unavailable song'**
  String get unavailableSong;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @nSongs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no songs} =1{1 song} other{{count} songs}}'**
  String nSongs(num count);

  /// No description provided for @searchYourPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Search Your Playlists'**
  String get searchYourPlaylists;

  /// No description provided for @typeToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get typeToSearch;

  /// No description provided for @errorLoadingSearch.
  ///
  /// In en, this message translates to:
  /// **'Error loading searching, please try again.'**
  String get errorLoadingSearch;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// No description provided for @emptyPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Empty Playlist !!!'**
  String get emptyPlaylist;

  /// No description provided for @errorReorder.
  ///
  /// In en, this message translates to:
  /// **'Error when trying to reorder the track, please try again.'**
  String get errorReorder;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @albumType.
  ///
  /// In en, this message translates to:
  /// **'{type, select, single{Single} album{Album} other{ }}'**
  String albumType(String type);

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @topSongs.
  ///
  /// In en, this message translates to:
  /// **'Top songs'**
  String get topSongs;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @loadMoreAlbums.
  ///
  /// In en, this message translates to:
  /// **'Load more albums'**
  String get loadMoreAlbums;

  /// No description provided for @likedSongs.
  ///
  /// In en, this message translates to:
  /// **'Liked Songs'**
  String get likedSongs;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlaying;

  /// No description provided for @nextFrom.
  ///
  /// In en, this message translates to:
  /// **'Next from:'**
  String get nextFrom;

  /// No description provided for @yourDevices.
  ///
  /// In en, this message translates to:
  /// **'Your devices'**
  String get yourDevices;

  /// No description provided for @onStandby.
  ///
  /// In en, this message translates to:
  /// **'On standby'**
  String get onStandby;

  /// No description provided for @currentDevice.
  ///
  /// In en, this message translates to:
  /// **'Current device'**
  String get currentDevice;

  /// No description provided for @visualizationOnly.
  ///
  /// In en, this message translates to:
  /// **'Visualization only'**
  String get visualizationOnly;

  /// No description provided for @noCompatibleDevices.
  ///
  /// In en, this message translates to:
  /// **'No compatible devices were found'**
  String get noCompatibleDevices;

  /// No description provided for @latestRelease.
  ///
  /// In en, this message translates to:
  /// **'Latest Release'**
  String get latestRelease;

  /// No description provided for @enjoyThisFeature.
  ///
  /// In en, this message translates to:
  /// **'Enjoy this feature on Spotify premium'**
  String get enjoyThisFeature;

  /// No description provided for @colabFollowsPlansRules.
  ///
  /// In en, this message translates to:
  /// **'Colab Helper follows Spotify plans rules.'**
  String get colabFollowsPlansRules;

  /// No description provided for @thisActionIsPremium.
  ///
  /// In en, this message translates to:
  /// **'This action is only available for Spotify premium users.'**
  String get thisActionIsPremium;

  /// No description provided for @spotifyPremiumLets.
  ///
  /// In en, this message translates to:
  /// **'Spotify Premium lets you play any track, podcast episode or audiobook, ad-free and with better audio quality. Go to '**
  String get spotifyPremiumLets;

  /// No description provided for @toTryit.
  ///
  /// In en, this message translates to:
  /// **' to try it for free.'**
  String get toTryit;

  /// No description provided for @syncLost.
  ///
  /// In en, this message translates to:
  /// **'Spotify sync connection was lost'**
  String get syncLost;

  /// No description provided for @syncPlsWait.
  ///
  /// In en, this message translates to:
  /// **'Syncing to Spotify, please wait.'**
  String get syncPlsWait;

  /// No description provided for @errorCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Error! Check your connection and try again later.'**
  String get errorCheckConnection;

  /// No description provided for @errorCrash.
  ///
  /// In en, this message translates to:
  /// **'If you are seeing this screen, your app/page crashed 😥'**
  String get errorCrash;

  /// No description provided for @spotifyNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Your device doesn\'t have the Spotify app installed'**
  String get spotifyNotInstalled;

  /// No description provided for @colabHelperUsesSpotify.
  ///
  /// In en, this message translates to:
  /// **'Colab Helper uses the Spotify app to sync and play tracks, please install Spotify before use this app.'**
  String get colabHelperUsesSpotify;

  /// No description provided for @getSpotifyFree.
  ///
  /// In en, this message translates to:
  /// **'GET SPOTIFY FREE'**
  String get getSpotifyFree;

  /// No description provided for @userType.
  ///
  /// In en, this message translates to:
  /// **'{type, select, premium{Premium} free{Free} other{ }}'**
  String userType(String type);

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit playlist'**
  String get editPlaylist;

  /// No description provided for @errorTryingToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Error trying to load image, please select another image.'**
  String get errorTryingToLoadImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @chooseFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Choose from camera'**
  String get chooseFromCamera;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @imageTooBig.
  ///
  /// In en, this message translates to:
  /// **'The selected Image is too big. please select another image.'**
  String get imageTooBig;

  /// No description provided for @imageUploadWarningOne.
  ///
  /// In en, this message translates to:
  /// **'By proceeding, you agree to give Spotify access to the image you choose to upload.'**
  String get imageUploadWarningOne;

  /// No description provided for @imageUploadWarningTwo.
  ///
  /// In en, this message translates to:
  /// **'Please make sure you have the right to upload the image.'**
  String get imageUploadWarningTwo;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @cancelChanges.
  ///
  /// In en, this message translates to:
  /// **'Cancel changes'**
  String get cancelChanges;

  /// No description provided for @discardChangesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard all the changes you made ?'**
  String get discardChangesConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @sometimesTakesTime.
  ///
  /// In en, this message translates to:
  /// **'Sometimes when saving playlist details, changes may take up to 1 minute to update on the page. You can manually refresh the playlist by pulling down to refresh.'**
  String get sometimesTakesTime;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
