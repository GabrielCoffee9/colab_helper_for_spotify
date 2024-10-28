import '../../../models/secundary models/queue.dart';
import '../../../shared/widgets/circular_progress.dart';
import '../../../shared/widgets/song_tile.dart';
import '../player_controller.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class QueueDialog extends StatefulWidget {
  const QueueDialog({super.key});

  @override
  State<QueueDialog> createState() => _QueueDialogState();
}

class _QueueDialogState extends State<QueueDialog> {
  Queue userQueue = Queue();
  PlayerController playerController = PlayerController.instance;

  late StreamSubscription? _playerStateListener;

  final ScrollController _scrollcontroller =
      ScrollController(initialScrollOffset: 0);

  bool loading = true;

  getQueueDialog() {
    playerController.getUserQueue().then((data) {
      if (mounted) {
        setState(() {
          userQueue = data;
          loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _playerStateListener = PlayerController.instance.playerState?.listen(
      (event) {
        if (event.track?.uri != userQueue.currentlyPlaying?.uri) {
          setState(() {
            loading = true;
          });

          getQueueDialog();
        }
      },
    );

    getQueueDialog();
  }

  @override
  void dispose() {
    _playerStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Queue"),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 34,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Now playing',
                  style: TextStyle(fontSize: 18),
                ),
                !loading
                    ? SongTile(
                        songName: userQueue.currentlyPlaying?.name,
                        artist: userQueue.currentlyPlaying?.artists?.first.name,
                        imageUrl:
                            userQueue.currentlyPlaying?.album?.images?[1].url,
                        playingNow: true,
                        selected: true,
                        invalidTrack: true,
                        onTap: () {})
                    : const Center(child: CircularProgress(isDone: false)),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8),
                  child: Text(
                    playerController.playerContext.value?.title != ''
                        ? 'Next from: ${playerController.playerContext.value?.title}'
                        : '${playerController.playerContext.value?.subtitle}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: loading
                      ? Container()
                      : Scrollbar(
                          controller: _scrollcontroller,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: _scrollcontroller,
                            itemCount: userQueue.items?.length ?? 0,
                            itemBuilder: (context, index) {
                              return SongTile(
                                  songName: userQueue.items?[index].name,
                                  artist: userQueue
                                      .items?[index].artists?.first.name,
                                  imageUrl: userQueue
                                      .items?[index].album?.images?[1].url,
                                  playingNow: false,
                                  selected: false,
                                  invalidTrack: true,
                                  onTap: () {
                                    // PlayerController.instance.playIndexPlaylist(trackIndex, contextUri);
                                  });
                            },
                          ),
                        ),
                ),
              ],
            ),
          )),
    );
  }
}
