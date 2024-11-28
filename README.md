<div align="center"> 
  <h1 align="center">
    Colab Helper for Spotify
  </h1>
  
  <p> <img width="300" height="300" src="https://i.imgur.com/OOvHVDD.png"> </p>
   
  <h3> 
    An app to explore Spotify features!
  </h3>
  
  [![en](https://img.shields.io/badge/lang-en-red.svg)](./README.md)
  [![pt-BR](https://img.shields.io/badge/lang-pt--BR-green.svg)](./README.pt-BR.md)

</div>


# About
Colab Helper is a Flutter Android app to help people add songs into collaborative playlists and interact with friends.

This application is for portfolio purposes and is not finished.


## Auth
- [x] Autommatically sync with spotify account
- [x] Check if spotify is installed on device
- [x] Reconnect dialog when spotify sync is lost

## User interactions
- [x] View all playlists
- [x] Follow/Unfollow an artist
- [x] Follow/Unfollow a playlist
- [x] Access liked songs
- [x] Reorder songs in a playlist
- [ ] Add more songs to a playlist

## Search
- [x] Playlists
- [x] Albums
- [x] Artist
- [ ] Podcasts
- [ ] Profiles

## Player
- [x] Player context
- [x] Content Cover Image 
- [x] Play/Pause a song
- [x] Skip/Back track (unlimited just for premium users)
- [x] 15 seconds foward/backwards in podcasts
- [x] Queue list (just for premium users)
- [x] Devices list (for free users this page is visualization only)
- [x] Add content to library button (like button)
- [ ] See a friend's progress bar if that friend is listening to the same song

## Social
- [ ] Search for friends in Colab App
- [ ] View the last song your friends were listening to
- [ ] Group chat to send previews of songs and decide whether the song should be added to a collaborative playlist

## Personalized settings

### Languages 
 - [x] English
 - [x] Portuguese brazilian

### Themes
 - [x]  System
 - [x]  Light mode
 - [x]  Dark mode




# Screenshots
### Dark mode
<p> 
  <img width="320" height="740" src="https://i.imgur.com/po3VWmY.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/YGcKQLQ.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/E1yU4qf.png" hspace="4">
</p>

### Light mode
<p> 
  <img width="320" height="740" src="https://i.imgur.com/ku0IQQs.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/hnYKmGS.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/KREaD0W.png" hspace="4">
</p>

## Development
Fork and clone the repository, then install the dependencies:

    flutter pub get

If you want to build this project, you will need an appClientId and an appRedirectURI provided in the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).

Create a new file called api-keys.json in the root of the project
```{json}
{
    "appClientId": "myAppClientId",
    "appRedirectURI": "myAppRedirectURI"
}
```
Tip: typically appRedirectURI is ```http://localhost:8888/callback```


Run the following to generate the translation files:

    flutter gen-l10n

Start the app with the dart define from file command:

    flutter run --dart-define-from-file api-keys.json
    
Also, please read this [warning](./WARNING.md).

## More info
If you are from Spotify and there is something wrong/not allowed in the project, please contact me via email.

If you have any questions about the project, please contact me via email.

Email: contactcoffeeapps@gmail.com

