import 'package:colab_helper_for_spotify/features/home/widgets/colab_playlist_card.dart';
import 'package:colab_helper_for_spotify/features/home/widgets/home_interactive_button.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlist_model.dart';
import 'package:colab_helper_for_spotify/shared/controllers/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';

import 'package:colab_helper_for_spotify/shared/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final controller = context.read<UserController>();
  late final playlistController = context.read<PlaylistController>();

  late Future<UserPlaylists> userPlaylists;

  @override
  void initState() {
    super.initState();

    userPlaylists = playlistController.getCurrentUserPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
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
                            imageUrl: controller.userProfile.images?.first.url),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.userProfile.displayName!),
                            Text(
                              'Spotify ${controller.userProfile.product}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        HomeInteractiveButton(
                            notificationCounter: 1,
                            onPressed: () {},
                            colors: colors,
                            iconButton: Icons.notifications_none_outlined),
                        const SizedBox(
                          width: 12,
                        ),
                        HomeInteractiveButton(
                            notificationCounter: 2,
                            onPressed: () {},
                            colors: colors,
                            iconButton: Icons.message_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                              onPressed: () {},
                              label: const Text('View all'),
                              icon: const Icon(Icons.navigate_before_outlined),
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
                      itemCount: 4,
                      cacheExtent: 4,
                      itemBuilder: (context, index) {
                        return ColabPlaylistCard(
                          onTap: () {
                            playlistController.getPlaylistItems(
                                snapshot.data!.items![index], 0);
                          },
                          playlistName: '${snapshot.data!.items![index].name}',
                          urlImage:
                              '${snapshot.data!.items![index].images!.first.url}',
                        );
                      },
                    );
                  } else {
                    return const Material();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
