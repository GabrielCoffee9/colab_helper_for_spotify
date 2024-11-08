import '../../models/primary models/user_profile_model.dart';
import '../../models/secundary models/album_model.dart';
import '../../shared/modules/user/user_controller.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/empty_playlist_cover.dart';
import '../../shared/widgets/profile_picture.dart';
import '../../shared/widgets/song_tile.dart';
import '../player/player_controller.dart';
import 'album_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({
    super.key,
    required this.initialAlbumData,
  });

  final Album initialAlbumData;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  PlayerController playerController = PlayerController.instance;

  AlbumController albumController = AlbumController();
  UserController userController = UserController();

  final ScrollController _scrollController = ScrollController();

  Album album = Album();

  String selectedSongUri = "";
  String? urlOwnerPlaylist;

  bool albumIsLoading = true;
  bool playerIsPaused = false;
  bool showScrollToTopButton = false;

  Future<void> getAlbum({int offset = 0}) async {
    if (album.tracks.isNotEmpty) {
      setState(() {
        albumIsLoading = false;
      });
      return;
    }
    albumController
        .getAlbum(album, UserProfile.instance.country, offset)
        .then((value) {
      setState(() {
        album = value;
        albumIsLoading = false;
      });
    });

    return;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    album = widget.initialAlbumData;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300) {
        if (!showScrollToTopButton) {
          setState(() {
            showScrollToTopButton = true;
          });
        }
      } else {
        setState(() {
          showScrollToTopButton = false;
        });
      }
    });

    playerController.getPlayerState().then((data) {
      setState(() {
        selectedSongUri = data?.track?.uri ?? '';
        playerIsPaused = data?.isPaused ?? true;
      });
    });

    if (playerController.playerStateListener != null) {
      playerController.playerStateListener!.listen((data) {
        setState(() {
          selectedSongUri = data.track?.uri ?? '';
          playerIsPaused = data.isPaused;
        });
      });
    }

    getAlbum();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      floatingActionButton: showScrollToTopButton
          ? FloatingActionButton(
              mini: true,
              child: const Icon(Icons.keyboard_double_arrow_up),
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastOutSlowIn,
                );
              })
          : null,
      appBar: AppBar(
        primary: true,
        // Disabled for now.
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.search),
        //   )
        // ],
      ),
      body: (albumIsLoading)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgress(isDone: false), Text('Loading')],
              ),
            )
          : Scrollbar(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            height: 220,
                            width: 220,
                            imageUrl: album.images.isNotEmpty
                                ? album.images.first.url!
                                : '',
                            memCacheWidth: 480,
                            memCacheHeight: 350,
                            maxWidthDiskCache: 480,
                            maxHeightDiskCache: 350,
                            imageBuilder: (context, image) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  image: image,
                                  fit: BoxFit.cover,
                                  // fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const EmptyPlaylistCover(),
                            errorWidget: (context, url, error) =>
                                const EmptyPlaylistCover(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Wrap(
                            children: [
                              Text(
                                albumIsLoading
                                    ? ''
                                    : album.name ?? 'Unnamed Album',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: ProfilePicture(
                                imageUrl:
                                    (album.artists.first.images.isNotEmpty)
                                        ? album.artists.first.images.last.url
                                        : '',
                                avatar: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(album.artists.first.name ?? ''),
                                  Row(
                                    children: [
                                      Text(
                                        ('${album.albumType?[0].toUpperCase() ?? 'Album'}${album.albumType?.substring(1)}'),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Icon(
                                          Icons.circle_rounded,
                                          size: 6,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Text(
                                        album.releaseDate!.split('-')[0],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Icon(
                                          Icons.circle_rounded,
                                          size: 6,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      Text(
                                        '${album.totalTracks!.toString()} ${album.totalTracks! > 1 ? 'songs' : 'song'}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: album.tracks.length,
                      itemBuilder: (context, index) {
                        if ((index + 1 > (album.tracks.length)) &&
                            albumController.state.value == AlbumState.loading) {
                          return Column(
                            key: Key('$index'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              LinearProgressIndicator(),
                              Text('Loading')
                            ],
                          );
                        }

                        return Padding(
                          key: Key('$index'),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SongTile(
                            songName: album.tracks[index].name,
                            artistName: album.tracks[index].allArtists,
                            showImage: false,
                            imageUrl:
                                album.tracks[index].album?.images.isNotEmpty ??
                                        false
                                    ? album.tracks[index].album!.images[1].url
                                    : '',
                            selected:
                                selectedSongUri == album.tracks[index].uri,
                            playingNow:
                                (selectedSongUri == album.tracks[index].uri) &&
                                    !playerIsPaused,
                            invalidTrack: album.tracks[index].invalid,
                            explicit: album.tracks[index].explicit ?? false,
                            onTap: () {
                              setState(() {
                                if (selectedSongUri ==
                                    album.tracks[index].uri) {
                                  playerIsPaused
                                      ? playerController.resume()
                                      : playerController.pause();
                                } else {
                                  playerController.skipToIndex(
                                      index -
                                          (album.tracks[index]
                                              .previousInvalidTracks),
                                      album.uri);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Center(
                      child: Text(album.copyrights.isNotEmpty
                          ? '${album.copyrights.first.text![0] != '©' ? '©' : ''} ${album.copyrights.first.text!}'
                          : ''),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
