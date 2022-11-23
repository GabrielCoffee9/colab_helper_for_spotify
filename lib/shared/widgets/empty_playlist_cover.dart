import 'package:flutter/material.dart';

class EmptyPlaylistCover extends StatelessWidget {
  const EmptyPlaylistCover({super.key, this.height, this.width, this.size});

  final double? height;
  final double? width;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        color: Colors.grey[800],
        child: Icon(
          Icons.music_note_outlined,
          color: Colors.white,
          size: size,
        ));
  }
}
