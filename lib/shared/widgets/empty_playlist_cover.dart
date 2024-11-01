import 'package:flutter/material.dart';

class EmptyPlaylistCover extends StatelessWidget {
  const EmptyPlaylistCover(
      {super.key, this.height = 142, this.width = 142, this.size = 80});

  final double height;
  final double width;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      height: height,
      width: width,
      child: Icon(
        Icons.music_note_outlined,
        color: Colors.white,
        size: size,
      ),
    );
  }
}
