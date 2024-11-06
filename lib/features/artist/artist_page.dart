import '../../models/primary models/user_profile_model.dart';
import '../../models/secundary models/artist_model.dart';
import '../../shared/modules/user/user_controller.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/song_tile.dart';
import '../player/player_controller.dart';
import 'artist_controller.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({
    super.key,
    required this.initialArtistData,
  });

  final Artist initialArtistData;

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  PlayerController playerController = PlayerController.instance;

  UserController userController = UserController();

  final ScrollController _scrollController = ScrollController();

  Artist artist = Artist();

  ValueNotifier<double> appBarTitleOpacity = ValueNotifier(0);
  ValueNotifier<double> flexibleSpaceTitleOpacity = ValueNotifier(1);

  String selectedSongUri = "";

  bool isPaused = false;

  bool showScrollToTopButton = false;

  final numberFormat = NumberFormat.compact();

  String? urlOwnerPlaylist;

  Future<void> getArtist({int offset = 0}) async {
    ArtistController().getArtist(artist.id).then((value) {
      setState(() {
        artist = value;
      });
    });

    return;
  }

  Future<void> getTopTracks() async {
    ArtistController()
        .getTopTracks(artist.id, UserProfile.instance.country)
        .then((value) {
      setState(() {
        artist.topTracks = value;
      });
    });
  }

  String formatFollowersCount(int? followers) {
    if (followers != null) {
      return numberFormat.format(followers);
    }

    return '';
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

    artist = widget.initialArtistData;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 130 &&
          _scrollController.position.pixels >= 0) {
        flexibleSpaceTitleOpacity.value =
            ((130 - _scrollController.position.pixels) / 130);
        if (flexibleSpaceTitleOpacity.value < 0.2) {
          flexibleSpaceTitleOpacity.value = 0;
        }
      }

      if (_scrollController.position.pixels <= 150 &&
          _scrollController.position.pixels >= 0) {
        appBarTitleOpacity.value = ((_scrollController.position.pixels) / 150);
      }
    });

    playerController.getPlayerState().then((data) {
      setState(() {
        selectedSongUri = data?.track?.uri ?? '';
        isPaused = data?.isPaused ?? true;
      });
    });

    if (playerController.playerStateListener != null) {
      playerController.playerStateListener!.listen((data) {
        setState(() {
          selectedSongUri = data.track?.uri ?? '';
          isPaused = data.isPaused;
        });
      });
    }

    getArtist();
    getTopTracks();
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
      body: artist.topTracks.isEmpty
          ? const Center(
              child: SizedBox(
                width: 40,
                child: CircularProgress(isDone: false),
              ),
            )
          : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 250,
                  title: ListenableBuilder(
                      listenable: appBarTitleOpacity,
                      builder: (context, snapshot) {
                        return AnimatedOpacity(
                            opacity: appBarTitleOpacity.value,
                            duration: Durations.short1,
                            child: Text(artist.name ?? ''));
                      }),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.all(8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ListenableBuilder(
                              listenable: flexibleSpaceTitleOpacity,
                              builder: (context, snapshot) {
                                return AnimatedOpacity(
                                  duration: Durations.short1,
                                  opacity: flexibleSpaceTitleOpacity.value,
                                  child: Text(
                                    artist.name ?? '',
                                    style: const TextStyle(fontSize: 34),
                                  ),
                                );
                              }),
                        ),
                        Text(
                          '${formatFollowersCount(artist.followersCount)} Followers',
                          style: const TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    background: Image.network(
                      opacity: const AlwaysStoppedAnimation(0.5),
                      fit: BoxFit.cover,
                      artist.images.isNotEmpty ? artist.images.first.url! : '',
                      errorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Top songs',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: artist.topTracks.length,
                          itemBuilder: (context, index) {
                            return SongTile(
                              songName: artist.topTracks[index].name,
                              artistName: artist.name,
                              imageUrl: null,
                              selected: selectedSongUri ==
                                  artist.topTracks[index].uri,
                              playingNow: (selectedSongUri ==
                                      artist.topTracks[index].uri) &&
                                  !isPaused,
                              invalidTrack: false,
                              explicit:
                                  artist.topTracks[index].explicit ?? false,
                              showImage: false,
                              onTap: () {
                                setState(() {
                                  if (selectedSongUri ==
                                      artist.topTracks[index].uri) {
                                    isPaused
                                        ? playerController.resume()
                                        : playerController.pause();
                                  } else {
                                    playerController.skipToIndex(
                                        0, artist.topTracks[index].uri);
                                  }
                                });
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
