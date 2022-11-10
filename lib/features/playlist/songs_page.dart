import 'package:flutter/material.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
    required this.playlistId,
  });

  final String playlistId;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs Page'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ListTile(
                  // title: Text(widget.songs.tracks!.name ?? 'Loading...'),
                  title: Text(''),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
