import 'package:colab_helper_for_spotify/features/home/widgets/home_interactive_button.dart';
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
  @override
  void initState() {
    super.initState();
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Colab Playlists',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.navigate_next_outlined))
                    ],
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
