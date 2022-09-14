import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key, required this.imageUrl});
  final String? imageUrl;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
        height: 48,
        fit: BoxFit.scaleDown,
        placeholder: kTransparentImage,
        image: widget.imageUrl ?? '');
  }
}
