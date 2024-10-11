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
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, _) => Container(color: Colors.transparent),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: 60,
        child: Icon(
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(image: image),
                ),
              )
          : null,
    );
  }
}
