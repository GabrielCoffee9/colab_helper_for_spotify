<<<<<<< Updated upstream
import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';
=======
import 'package:colab_helper_for_spotify/features/home/widgets/home_interactive_button.dart';
import 'package:colab_helper_for_spotify/shared/controllers/playlist_controller.dart';
import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';

import 'package:colab_helper_for_spotify/shared/widgets/profile_picture.dart';
>>>>>>> Stashed changes
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
    return Scaffold(
<<<<<<< Updated upstream
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home_outlined)),
          NavigationDestination(
              label: 'Search', icon: Icon(Icons.search_outlined)),
          NavigationDestination(
              label: 'Add', icon: Icon(Icons.add_circle_outline)),
          NavigationDestination(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
          ),
        ],
        selectedIndex: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      controller.userProfile.images?.first.url == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person_outline_rounded,
                                size: 32,
                                color: Colors.black,
                              ))
                          : CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 32,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                    controller.userProfile.images?.first.url ??
                                        ''),
                              )),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.userProfile.displayName!),
                          Text(
                            'Spotify ${controller.userProfile.product}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
=======
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
                            notificationCounter: 0,
                            onPressed: () {},
                            colors: colors,
                            iconButton: Icons.notifications_none_outlined),
                        const SizedBox(
                          width: 12,
                        ),
                        HomeInteractiveButton(
                            notificationCounter: 0,
                            onPressed: () {},
                            colors: colors,
                            iconButton: Icons.message_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [],
>>>>>>> Stashed changes
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
<<<<<<< Updated upstream
                      SizedBox(
                        height: 52,
                        width: 54,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 52,
                        width: 54,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.message_outlined,
                            size: 24,
                          ),
                        ),
                      )
=======
                      Text(
                        'Colab Playlists',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.navigate_next_outlined))
>>>>>>> Stashed changes
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    color: Colors.white,
                  )
                ],
              ),
<<<<<<< Updated upstream
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      hintText: 'Search anything you want',
                      prefixIcon: const Icon(Icons.search_outlined)),
                ),
              ),
            ],
          ),
=======
            )
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}
