import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_items_model.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    super.key,
    required this.playlistItems,
  });

  final PlaylistItems playlistItems;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const ListTile();
          },
        )
      ],
    );
  }
}
