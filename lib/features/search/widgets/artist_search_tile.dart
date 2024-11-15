import '../../../models/secundary models/artist_model.dart';
import '../../../shared/modules/appLocalizations/localizations_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtistSearchTile extends StatelessWidget {
  const ArtistSearchTile({super.key, required this.artist, this.onTap});

  final Artist artist;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name ?? LocalizationsController.of(context)!.loading),
      subtitle: Text(
        LocalizationsController.of(context)!.artist,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      leading: SizedBox(
        height: 56,
        width: 56,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl:
              artist.images.isNotEmpty ? artist.images.last.url ?? '' : '',
          imageBuilder: (context, image) => Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          memCacheWidth: 147,
          memCacheHeight: 147,
          maxWidthDiskCache: 147,
          maxHeightDiskCache: 147,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            width: 56,
            child: const Icon(
              Icons.person_outlined,
              color: Colors.white,
              size: 56,
            ),
          ),
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
        ),
      ),
      onTap: onTap,
    );
  }
}
