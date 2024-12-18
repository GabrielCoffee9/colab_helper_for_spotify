import '../modules/appLocalizations/localizations_controller.dart';
import 'empty_playlist_cover.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songName,
    required this.artistName,
    this.showImage = true,
    required this.imageUrl,
    required this.playingNow,
    required this.selected,
    required this.invalidTrack,
    required this.explicit,
    required this.onTap,
  });
  final String? songName;
  final String? artistName;
  final bool showImage;
  final String? imageUrl;
  final bool selected;
  final bool playingNow;
  final bool invalidTrack;
  final bool explicit;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      child: ListTile(
        key: key,
        selected: selected,
        selectedColor: colors.primary,
        contentPadding: const EdgeInsets.all(8),
        tileColor: colors.surface,
        selectedTileColor: colors.secondaryContainer,
        title: songName?.isNotEmpty ?? false
            ? Text(
                songName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                LocalizationsController.of(context)!.unavailableSong,
                style: const TextStyle(color: Colors.red),
              ),
        subtitle: Row(
          children: [
            if (explicit)
              const Icon(
                Icons.explicit,
                size: 16,
                // color: Theme.of(context).colorScheme.tertiary,
              ),
            Expanded(
              child: Text(
                artistName ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: showImage
            ? SizedBox(
                width: 56,
                height: 56,
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  imageBuilder: (context, image) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      ),
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
                  errorWidget: (context, url, error) =>
                      const EmptyPlaylistCover(
                    height: 150,
                    width: 170,
                    size: 40,
                  ),
                ),
              )
            : null,
        trailing: invalidTrack
            ? null
            : playingNow
                ? const Icon(
                    Icons.pause_circle,
                    size: 40,
                  )
                : const Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                  ),
        onTap: invalidTrack ? null : onTap,
      ),
    );
  }
}
