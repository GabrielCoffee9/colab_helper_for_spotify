import '../../../models/secundary models/playlist_model.dart';
import '../../../shared/widgets/empty_playlist_cover.dart';
import '../../../shared/widgets/music_visualizer.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistSearchTile extends StatelessWidget {
  const PlaylistSearchTile(
      {super.key, required this.playlist, required this.isPlaying, this.onTap});

  final Playlist playlist;

  final bool isPlaying;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name ?? 'Loading...'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(playlist.owner?.displayName ?? ''),
          Text(
            'Playlist',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
      leading: SizedBox(
        width: 56,
        height: 56,
        child: CachedNetworkImage(
          imageUrl:
              playlist.images!.isNotEmpty ? playlist.images!.last.url! : '',
          imageBuilder: (context, image) => Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          memCacheWidth: 147,
          memCacheHeight: 147,
          maxWidthDiskCache: 147,
          maxHeightDiskCache: 147,
          placeholder: (context, url) => const EmptyPlaylistCover(
            height: 150,
            width: 170,
            size: 40,
          ),
          errorWidget: (context, url, error) => const EmptyPlaylistCover(
            height: 150,
            width: 170,
            size: 40,
          ),
        ),
      ),
      trailing: isPlaying
          ? const MusicVisualizer(
              unitAudioWavecount: 3,
              lineWidth: 2,
              width: 20,
              circularBorderRadius: 4,
            )
          : null,
      onTap: onTap,
    );
  }
}
