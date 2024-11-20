import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {super.key, required this.imageUrl, this.avatar = false});
  final String? imageUrl;
  final bool avatar;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      memCacheHeight: 210,
      memCacheWidth: 210,
      maxWidthDiskCache: 210,
      maxHeightDiskCache: 210,
      height: 60,
      placeholder: (context, _) => Container(color: Colors.transparent),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        width: 60,
        child: const Icon(
          Icons.person_outlined,
          color: Colors.white,
          size: 60,
        ),
      ),
      imageUrl: imageUrl ?? '',
      imageBuilder: avatar
          ? (context, image) => Container(
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              )
          : null,
    );
  }
}
