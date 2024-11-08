import '../../../models/secundary models/album_model.dart';
import '../../../shared/widgets/empty_playlist_cover.dart';
import '../../../shared/widgets/music_visualizer.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumSearchTile extends StatelessWidget {
  const AlbumSearchTile(
      {super.key, required this.album, required this.isPlaying, this.onTap});

  final Album album;

  final bool isPlaying;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(album.name ?? 'Loading...'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(album.artists.first.name ?? ''),
          Row(
            children: [
              Text(
                ('${album.albumType?[0].toUpperCase() ?? 'Album'}${album.albumType?.substring(1)}'),
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  Icons.circle_rounded,
                  size: 6,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Text(
                album.releaseDate!.split('-')[0],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
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
          imageUrl: album.images.isNotEmpty ? album.images.last.url! : '',
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
      onTap: onTap,
    );
  }
}
