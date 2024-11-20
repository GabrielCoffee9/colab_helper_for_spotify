// ignore_for_file: use_build_context_synchronously

import '../../../models/secundary models/playlist_model.dart';
import '../../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../../shared/widgets/build_snackbar.dart';
import '../../../shared/widgets/empty_playlist_cover.dart';
import '../playlist_controller.dart';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaylistDialog extends StatefulWidget {
  const EditPlaylistDialog({super.key, required this.targetPlaylist});

  final Playlist targetPlaylist;

  @override
  State<EditPlaylistDialog> createState() => _EditPlaylistDialogState();
}

class _EditPlaylistDialogState extends State<EditPlaylistDialog> {
  XFile? selectedTempImage;
  bool imageError = false;
  PlaylistController playlistController = PlaylistController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  bool privatePlaylist = false;
  bool collaborativePlaylist = false;
  double? circularProgressValue = 0;
  bool savingChanges = false;

  String initialPlaylistName = '';
  String initialDescription = '';

  saveChanges() async {
    if (savingChanges) {
      return;
    }

    setState(() {
      savingChanges = true;
    });

    if (selectedTempImage != null) {
      final imageData = await selectedTempImage!.readAsBytes();
      if (mounted) {
        setState(() {
          circularProgressValue = null;
        });
      }

      await playlistController.uploadCustomCoverImage(
          widget.targetPlaylist.id, imageData);
    }

    await playlistController.updatePlaylistDetails(
        widget.targetPlaylist.id,
        titleTextEditingController.text,
        descriptionTextEditingController.text,
        privatePlaylist,
        collaborativePlaylist);

    Navigator.of(context, rootNavigator: true).pop(true);
  }

  @override
  void initState() {
    super.initState();
    titleTextEditingController.text = widget.targetPlaylist.name ?? '';
    descriptionTextEditingController.text =
        widget.targetPlaylist.description ?? '';
    privatePlaylist = !(widget.targetPlaylist.public ?? true);
    collaborativePlaylist = widget.targetPlaylist.collaborative ?? false;

    initialPlaylistName = widget.targetPlaylist.name ?? '';
    initialDescription = widget.targetPlaylist.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  LocalizationsController.of(context)!.editPlaylist,
                  style: const TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (selectedTempImage == null)
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CachedNetworkImage(
                    imageUrl: widget.targetPlaylist.images!.isNotEmpty
                        ? widget.targetPlaylist.images!.first.url!
                        : '',
                    memCacheWidth: 480,
                    memCacheHeight: 350,
                    maxWidthDiskCache: 480,
                    maxHeightDiskCache: 350,
                    imageBuilder: (context, image) => Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        image: DecorationImage(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const EmptyPlaylistCover(),
                    errorWidget: (context, url, error) =>
                        const EmptyPlaylistCover(),
                  ),
                ),
              if (selectedTempImage != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          width: 220,
                          height: 220,
                          File(selectedTempImage!.path),
                          errorBuilder: (context, error, stackTrace) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  imageError = true;
                                });
                              }
                            });

                            return Center(
                              child: Text(LocalizationsController.of(context)!
                                  .errorTryingToLoadImage),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CircularProgressIndicator(value: circularProgressValue)
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: OutlinedButton(
                  child: Text(LocalizationsController.of(context)!.changeImage),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 230,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: Text(
                                        LocalizationsController.of(context)!
                                            .chooseFromCamera),
                                    onTap: () async {
                                      final imagePickerCamera =
                                          await ImagePicker().pickImage(
                                              requestFullMetadata: false,
                                              imageQuality: 90,
                                              source: ImageSource.camera);
                                      if (imagePickerCamera == null) return;
                                      setState(() {
                                        selectedTempImage = imagePickerCamera;
                                      });
                                      if (mounted) {
                                        Navigator.of(context).pop('false');
                                        imageError = false;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    width: 250,
                                    child: ListTile(
                                      leading:
                                          const Icon(Icons.file_upload_rounded),
                                      title: Text(
                                          LocalizationsController.of(context)!
                                              .chooseFromGallery),
                                      onTap: () async {
                                        final imagePickerFile =
                                            await ImagePicker().pickImage(
                                                requestFullMetadata: false,
                                                imageQuality: 90,
                                                source: ImageSource.gallery);
                                        if (imagePickerFile == null) return;

                                        final bytesCount =
                                            await imagePickerFile.length();

                                        if (bytesCount > 206000) {
                                          buildSnackBar(context,
                                              error: LocalizationsController.of(
                                                      context)!
                                                  .imageTooBig);
                                          return;
                                        }

                                        setState(() {
                                          selectedTempImage = imagePickerFile;
                                        });
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                          imageError = false;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 350,
                                  child: Text(
                                      LocalizationsController.of(context)!
                                          .imageUploadWarningOne
                                      // style: TextStyle(fontSize: 10),
                                      ),
                                ),
                                SizedBox(
                                  width: 350,
                                  child: Text(
                                    LocalizationsController.of(context)!
                                        .imageUploadWarningTwo,
                                    // style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationsController.of(context)!.title,
                  style: const TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: titleTextEditingController,
                  maxLength: 100,
                  maxLines: 1,
                ),
                Text(
                  LocalizationsController.of(context)!.description,
                  style: const TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: descriptionTextEditingController,
                  maxLength: 300,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                // const Text('Private'),
                // Switch(
                //     value: privatePlaylist,
                //     onChanged: (newValue) {
                //       setState(() {
                //         privatePlaylist = newValue;
                //         if (!newValue) {
                //           collaborativePlaylist = false;
                //         }
                //       });
                //     }),
                // const Text('Collaborative'),
                // Switch(
                //     value: collaborativePlaylist,
                //     onChanged: (newValue) {
                //       setState(() {
                //         if (!privatePlaylist) {
                //           return;
                //         }
                //         collaborativePlaylist = newValue;
                //       });
                //     }),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: savingChanges
                    ? null
                    : () async {
                        if (initialPlaylistName ==
                                titleTextEditingController.text &&
                            initialDescription ==
                                descriptionTextEditingController.text &&
                            selectedTempImage == null) {
                          Navigator.of(context).pop();
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(LocalizationsController.of(context)!
                                  .cancelChanges),
                              content: Text(LocalizationsController.of(context)!
                                  .discardChangesConfirmation),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                      LocalizationsController.of(context)!
                                          .cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      LocalizationsController.of(context)!.yes),
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Text(LocalizationsController.of(context)!.cancel),
              ),
              OutlinedButton(
                onPressed: savingChanges
                    ? null
                    : () async {
                        await saveChanges();
                      },
                child: Text(LocalizationsController.of(context)!.save),
              ),
            ],
          )
        ],
      ),
    );
  }
}
