import '../../models/primary models/user_playlists_model.dart';
import '../../models/primary models/user_profile_model.dart';
import '../../shared/modules/user/user_controller.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/colab_playlist_card.dart';
import '../../shared/widgets/music_visualizer.dart';
import '../../shared/widgets/profile_picture.dart';
import '../auth/auth_controller.dart';
import '../player/player_controller.dart';
import '../playlist/all_playlists_page.dart';
import '../playlist/playlist_controller.dart';
import '../playlist/playlist_page.dart';
import '../search/search_page.dart';
import 'widgets/home_interactive_button.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  PlaylistController playlistController = PlaylistController();

  AuthController authController = AuthController.instance;

  UserPlaylists userPlaylists = UserPlaylists();

  bool userPlaylistsIsLoading = true;

  bool playerIsPaused = true;

  void getUserProfile() {
    UserController().getUserProfile().then((_) {
      setState(() {});
    });
  }

  Future<void> getPlaylists({int offset = 0}) async {
    playlistController.getCurrentUserPlaylists(limit: 5, offset: offset).then(
      (value) {
        setState(() {
          userPlaylists = value;
          userPlaylistsIsLoading = false;
        });
      },
    );

    return;
  }

  getPlayerPausedState() {
    PlayerController.instance
        .getPlayerState()
        .then((data) => playerIsPaused = data?.isPaused ?? true);
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

    AuthController.instance.connectionStatus.listen(
      (event) {
        if (event.connected) {
          setState(() {});
        }
      },
    );

    getUserProfile();
    getPlaylists();
    getPlayerPausedState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = UserProfile.instance;
    final ColorScheme colors = Theme.of(context).colorScheme;
    int playlistItemsLength = userPlaylists.playlists.length;
    int maxDisplayedPlaylists =
        playlistItemsLength > 5 ? 5 : playlistItemsLength;
    return Scaffold(
      key: _key,
      drawer: const Drawer(),
      backgroundColor: colors.surface,
      body: RefreshIndicator(
        onRefresh: () => getPlaylists(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverAppBar(
              leadingWidth: 50,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  if (mounted) _key.currentState?.openDrawer();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchPage(),
                    );
                  },
                )
              ],
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: StreamBuilder(
                    stream: PlayerController.instance.playerStateListener,
                    builder: (context, snapshot) {
                      playerIsPaused =
                          snapshot.data?.isPaused ?? playerIsPaused;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1400),
                        switchInCurve: Curves.bounceIn,
                        switchOutCurve: Curves.bounceOut,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: playerIsPaused
                              ? GestureDetector(
                                  onTap: (() => PlayerController.instance
                                      .showPlayerDialog(context)),
                                  child: AppLogo(
                                    iconSize: 36,
                                    darkTheme:
                                        colors.brightness == Brightness.dark,
                                  ),
                                )
                              : const MusicVisualizer(
                                  unitAudioWavecount: 8,
                                  lineWidth: 4,
                                  width: 60,
                                  circularBorderRadius: 12,
                                ),
                        ),
                      );
                    },
                  )),
            ),
            userPlaylistsIsLoading
                ? const SliverToBoxAdapter(child: Material())
                : SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: ProfilePicture(
                                      imageUrl: userProfile.images.isNotEmpty
                                          ? userProfile.images.first.url
                                          : '',
                                      avatar: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(userProfile.displayName ?? ''),
                                      Text(
                                        '${userProfile.product}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  HomeInteractiveButton(
                                    notificationCounter: 0,
                                    colors: colors,
                                    iconButton:
                                        Icons.notifications_none_outlined,
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 8),
                                  HomeInteractiveButton(
                                    notificationCounter: 0,
                                    colors: colors,
                                    iconButton: Icons.message_outlined,
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 2),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "lib/assets/Spotify_Logo_RGB_Green.png",
                                    height: 35,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Playlists',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Row(
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AllPlaylistsPage(),
                                              ),
                                            );
                                          },
                                          label: const Text('View all'),
                                          icon: const Icon(
                                            Icons.navigate_before_outlined,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: maxDisplayedPlaylists,
                            cacheExtent: maxDisplayedPlaylists.toDouble(),
                            itemBuilder: (context, index) {
                              return ColabPlaylistCard(
                                playlistName:
                                    userPlaylists.playlists[index].name ??
                                        'Loading',
                                urlImage: userPlaylists.playlists[index].images
                                            ?.isNotEmpty ??
                                        false
                                    ? userPlaylists
                                        .playlists[index].images?.first.url
                                    : null,
                                onTap: () {
                                  if (userPlaylists.playlists.isNotEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistPage(
                                          initialPlaylistData:
                                              userPlaylists.playlists[index],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
