import 'package:cached_network_image/cached_network_image.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';

class ColabPlaylistCard extends StatelessWidget {
  const ColabPlaylistCard({
    super.key,
    required this.playlistName,
    required this.urlImage,
    required this.onTap,
  });

  final String playlistName;
  final String? urlImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 175,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(4),
          color: colors.secondaryContainer,
          surfaceTintColor: colors.surface,
          child: Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                  height: 142,
                  width: 142,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const EmptyPlaylistCover(),
                    errorWidget: (context, url, error) =>
                        const EmptyPlaylistCover(),
                    imageUrl: urlImage ?? '',
                    memCacheWidth: 372,
                    memCacheHeight: 372,
                    maxWidthDiskCache: 372,
                    maxHeightDiskCache: 372,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlistName,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 8),
                        const SizedBox(width: 4),
                        Text('Playlist'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
