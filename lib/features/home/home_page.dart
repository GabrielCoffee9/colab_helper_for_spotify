import 'package:colab_helper_for_spotify/features/playlist/all_playlists_page.dart';
import 'package:colab_helper_for_spotify/shared/widgets/colab_playlist_card.dart';
import 'package:colab_helper_for_spotify/features/home/widgets/home_interactive_button.dart';
import 'package:colab_helper_for_spotify/features/playlist/playlist_page.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_profile_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/widgets/app_logo.dart';

import 'package:colab_helper_for_spotify/shared/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlaylistController playlistController = PlaylistController();
  late Future<UserPlaylists> userPlaylists;

  Future<void> refreshHome() {
    playlistController.clearPlaylistsMemory();
    setState(() {
      userPlaylists =
          playlistController.getCurrentUserPlaylists(limit: 5, offset: 0);
    });

    return userPlaylists;
  }

  @override
  void initState() {
    refreshHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = UserProfile.instance;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () => refreshHome(),
        child: CustomScrollView(
          physics: const ScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverAppBar(
              leadingWidth: 50,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                )
              ],
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: AppLogo(
                    iconSize: 36,
                    darkTheme: colors.brightness == Brightness.dark),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    color: colors.background,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ProfilePicture(
                                  imageUrl: userProfile.images?.first.url),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userProfile.displayName!),
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
                                  onPressed: () {},
                                  colors: colors,
                                  iconButton:
                                      Icons.notifications_none_outlined),
                              const SizedBox(
                                width: 8,
                              ),
                              HomeInteractiveButton(
                                  notificationCounter: 0,
                                  onPressed: () {},
                                  colors: colors,
                                  iconButton: Icons.message_outlined),
                              const SizedBox(width: 2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Playlists',
                              style: Theme.of(context).textTheme.titleLarge,
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
                                              AllPlaylistsPage(
                                            userPlaylists: userPlaylists,
                                          ),
                                        ),
                                      );
                                    },
                                    label: const Text('View all'),
                                    icon: const Icon(
                                        Icons.navigate_before_outlined),
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
                    child: FutureBuilder(
                      future: userPlaylists,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                snapshot.data!.playlists!.isNotEmpty ? 5 : 0,
                            cacheExtent: 5,
                            itemBuilder: (context, index) {
                              return ColabPlaylistCard(
                                onTap: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistPage(
                                        playlist:
                                            snapshot.data!.playlists![index],
                                      ),
                                    ),
                                  );
                                },
                                playlistName:
                                    '${snapshot.data!.playlists![index].name}',
                                urlImage: snapshot.data!.playlists![index]
                                        .images!.isNotEmpty
                                    ? snapshot.data!.playlists![index].images!
                                        .first.url
                                    : null,
                              );
                            },
                          );
                        }
                        return const Material();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
