import 'package:colab_helper_for_spotify/shared/widgets/empty_playlist_cover.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.playingNow,
    required this.onTap,
  });
  final String? songName;
  final String? artist;
  final String? imageUrl;
  final bool playingNow;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    return Material(
      color: colors.background,
      child: ListTile(
        key: key,
        selected: playingNow,
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
        leading: imageUrl?.isNotEmpty ?? false
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage, image: imageUrl ?? '')
            : EmptyPlaylistCover(
                size: 30,
                height: screenSize.height / 8,
                width: screenSize.width / 7,
              ),
        trailing: playingNow
            ? const Icon(
                Icons.pause_circle,
                size: 40,
              )
            : const Icon(
                Icons.play_arrow_rounded,
                size: 40,
              ),
        onTap: onTap,
      ),
    );
  }
}
