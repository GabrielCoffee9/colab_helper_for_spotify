import 'package:cached_network_image/cached_network_image.dart';
import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.playingNow,
    required this.selected,
    required this.invalidTrack,
    required this.onTap,
  });
  final String? songName;
  final String? artist;
  final String? imageUrl;
  final bool selected;
  final bool playingNow;
  final bool invalidTrack;
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
        title: songName?.isNotEmpty ?? false
            ? Text(
                songName ?? 'Error',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : const Text(
                'Unavailable song',
                style: TextStyle(color: Colors.red),
              ),
        subtitle: artist?.isNotEmpty ?? false
            ? Text(
                artist ?? '',
                overflow: TextOverflow.ellipsis,
              )
            : const Text('Unknown artist'),
        leading: SizedBox(
          width: 56,
          height: 56,
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            memCacheWidth: 147,
            memCacheHeight: 147,
            maxWidthDiskCache: 147,
            maxHeightDiskCache: 147,
            placeholder: (context, url) => Container(color: Colors.transparent),
            errorWidget: (context, url, error) => EmptyPlaylistCover(
              height: 150,
              width: 170,
              size: 60,
            ),
          ),
        ),
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
