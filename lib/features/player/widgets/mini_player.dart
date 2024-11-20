import '../../../shared/widgets/empty_playlist_cover.dart';
import '../../../shared/widgets/play_and_pause_button.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
    required this.opacityValue,
    this.trackImageUri,
    required this.trackName,
    required this.trackArtistName,
    required this.playerCurrentPosition,
    required this.trackDuration,
    required this.isplaying,
    this.playAndPauseButtonPressed,
    this.gestureDectectorOnTap,
  });

  final double opacityValue;
  final String? trackImageUri;
  final String trackName;
  final String trackArtistName;
  final int playerCurrentPosition;
  final int trackDuration;
  final bool isplaying;
  final void Function()? playAndPauseButtonPressed;
  final void Function()? gestureDectectorOnTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacityValue,
      duration: Durations.short2,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        height: 50,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: gestureDectectorOnTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'lib/assets/Spotify_Icon_RGB_Green.png',
                      height: 30,
                      cacheWidth: 140,
                      cacheHeight: 140,
                    ),
                    if (trackImageUri != null)
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CachedNetworkImage(
                          memCacheHeight: 140,
                          memCacheWidth: 140,
                          maxHeightDiskCache: 140,
                          maxWidthDiskCache: 140,
                          placeholder: (context, url) =>
                              const EmptyPlaylistCover(
                            size: 15,
                          ),
                          errorWidget: (context, url, error) =>
                              const EmptyPlaylistCover(
                            size: 15,
                          ),
                          imageUrl: 'https://i.scdn.co/image/$trackImageUri',
                          imageBuilder: (context, image) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            trackName,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(trackArtistName, style: const TextStyle())
                        ],
                      ),
                    ),
                    PlayAndPauseButton(
                      size: 20,
                      playing: isplaying,
                      onPressed: playAndPauseButtonPressed,
                    ),
                  ],
                ),
              ),
            ),
            ProgressBar(
              thumbRadius: 0,
              timeLabelPadding: 0,
              barHeight: 2,
              timeLabelLocation: TimeLabelLocation.none,
              onSeek: null,
              progress: Duration(milliseconds: playerCurrentPosition),
              total: Duration(milliseconds: trackDuration),
            ),
          ],
        ),
      ),
    );
  }
}
