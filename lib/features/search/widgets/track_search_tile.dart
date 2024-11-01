import '../../../models/secundary models/track_model.dart';
import '../../../shared/widgets/empty_playlist_cover.dart';
import '../../../shared/widgets/music_visualizer.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrackSearchTile extends StatelessWidget {
  const TrackSearchTile(
      {super.key, required this.track, required this.isPlaying, this.onTap});

  final Track track;

  final bool isPlaying;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name ?? 'Loading...'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(track.artists.first.name ?? ''),
          Row(
            children: [
              Row(
                children: [
                  if (track.explicit ?? false)
                    Icon(
                      Icons.explicit,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  Text(
                    'Track',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
              if (isPlaying)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: MusicVisualizer(
                    unitAudioWavecount: 3,
                    lineWidth: 1.5,
                    width: 15,
                    circularBorderRadius: 4,
                  ),
                ),
            ],
          )
        ],
      ),
      leading: SizedBox(
        width: 56,
        height: 56,
        child: CachedNetworkImage(
          imageUrl: track.album?.images.isNotEmpty ?? false
              ? track.album?.images.last.url ?? ''
              : '',
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
      trailing: GestureDetector(
        child: const Icon(Icons.more_vert),
        onTap: () {},
      ),
      onTap: onTap,
    );
  }
}
