import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
        height: 60,
        fit: BoxFit.scaleDown,
        placeholder: kTransparentImage,
        image: imageUrl ?? '');
  }
}
