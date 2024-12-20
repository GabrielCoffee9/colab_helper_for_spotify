import '../../../models/primary models/user_profile_model.dart';
import '../../../models/secundary models/devices_model.dart';
import '../../../shared/modules/appLocalizations/localizations_controller.dart';
import '../player_controller.dart';

import 'package:flutter/material.dart';

class DevicesDialog extends StatefulWidget {
  const DevicesDialog({super.key});

  @override
  State<DevicesDialog> createState() => _DevicesDialogState();
}

class _DevicesDialogState extends State<DevicesDialog> {
  List<Devices> devicesList = [];
  PlayerController playlistController = PlayerController.instance;

  bool isloading = false;

  void getCurrentDevices() {
    if (mounted && !isloading) {
      setState(() {
        isloading = true;
      });
      playlistController.getAvailableDevices().then((data) {
        if (mounted) {
          setState(() {
            devicesList = data;
            isloading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentDevices();
  }

  @override
  Widget build(BuildContext context) {
    bool currentUserIsFree = UserProfile.instance.isFreeUser;

    return SimpleDialog(
      title: Text(LocalizationsController.of(context)!.yourDevices),
      children: [
        if (currentUserIsFree)
          Chip(
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            avatar:
                Icon(Icons.info, color: Theme.of(context).colorScheme.tertiary),
            label: Text(
                'Spotify Free - ${LocalizationsController.of(context)!.visualizationOnly}'),
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        SizedBox(
          height: 400,
          width: 300,
          child: devicesList.isNotEmpty
              ? ListView.builder(
                  itemCount: devicesList.length,
                  itemBuilder: (context, index) {
                    return SimpleDialogOption(
                      child: Column(
                        children: [
                          IgnorePointer(
                            ignoring: currentUserIsFree,
                            child: DeviceTile(
                              deviceName: devicesList[index].name ?? '',
                              deviceType: devicesList[index].type ?? '',
                              active: devicesList[index].isActive ?? false,
                              onTap: () {
                                playlistController
                                    .transferPlayback(devicesList[index].id)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      for (var element in devicesList) {
                                        element.isActive = false;
                                      }
                                      devicesList[index].isActive = true;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  LocalizationsController.of(context)!.noCompatibleDevices,
                )),
        ),
      ],
    );
  }
}

const devicesIconList = {
  "Smartphone": Icons.smartphone_outlined,
  "Computer": Icons.computer_outlined,
  "Speaker": Icons.speaker,
};

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.deviceName,
    required this.deviceType,
    required this.active,
    required this.onTap,
  });

  final String deviceType;
  final String deviceName;
  final bool active;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Icon(devicesIconList[deviceType]),
        title: Text(deviceName),
        subtitle: active
            ? Text(LocalizationsController.of(context)!.currentDevice)
            : Text(LocalizationsController.of(context)!.onStandby),
        selected: active,
        onTap: onTap,
      ),
    );
  }
}
