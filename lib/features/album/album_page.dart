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

  ValueNotifier<bool> isAlbumLoading = ValueNotifier(true);

  String selectedSongUri = "";

  bool isPaused = false;

  bool showScrollToTopButton = false;

  String? urlOwnerPlaylist;

  Future<void> getAlbum({int offset = 0}) async {
    albumController
        .getAlbum(album, UserProfile.instance.country, offset)
        .then((value) {
      setState(() {
        album = value;
        isAlbumLoading.value = false;
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
        isPaused = data?.isPaused ?? true;
      });
    });

    if (playerController.playerState != null) {
      playerController.playerState!.listen((data) {
        setState(() {
          selectedSongUri = data.track?.uri ?? '';
          isPaused = data.isPaused;
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
                    curve: Curves.fastOutSlowIn);
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
      body: (isAlbumLoading.value)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgress(isDone: false), Text('Loading')],
              ),
            )
          : Scrollbar(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: CachedNetworkImage(
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
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    const EmptyPlaylistCover(),
                                errorWidget: (context, url, error) =>
                                    const EmptyPlaylistCover()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAlbumLoading.value
                                      ? ''
                                      : album.name ?? 'Unnamed Album',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: colors.onSurface,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: ProfilePicture(
                                          imageUrl: (album.artists.first.images
                                                  .isNotEmpty)
                                              ? album
                                                  .artists.first.images.last.url
                                              : '',
                                          avatar: true,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                album.artists.first.name ?? ''),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0,
                                                          right: 4.0),
                                                  child: Icon(
                                                      Icons.circle_rounded,
                                                      size: 6,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                                ),
                                                Text(
                                                  album.releaseDate!
                                                      .split('-')[0],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: album.tracks.length,
                    itemBuilder: (context, index) {
                      if ((index + 1 >= (album.tracks.length)) &&
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
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          key: Key('$index'),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: colors.outline, width: 0.5),
                            ),
                          ),
                          child: ReorderableDelayedDragStartListener(
                            enabled: false,
                            index: index,
                            child: SongTile(
                              key: Key('$index'),
                              songName: album.tracks[index].name,
                              artist: album.tracks[index].allArtists,
                              showImage: false,
                              imageUrl: album.tracks[index].album?.images
                                          .isNotEmpty ??
                                      false
                                  ? album.tracks[index].album!.images[1].url
                                  : '',
                              selected:
                                  selectedSongUri == album.tracks[index].uri,
                              playingNow: (selectedSongUri ==
                                      album.tracks[index].uri) &&
                                  !isPaused,
                              invalidTrack: album.tracks[index].invalid,
                              explicit: album.tracks[index].explicit ?? false,
                              onTap: () {
                                setState(() {
                                  if (selectedSongUri ==
                                      album.tracks[index].uri) {
                                    isPaused
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
                          ),
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Expanded(
                        child: Center(
                          child: Text(album.copyrights.isNotEmpty
                              ? '${album.copyrights.first.text![0] != '©' ? '©' : ''} ${album.copyrights.first.text!}'
                              : ''),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
