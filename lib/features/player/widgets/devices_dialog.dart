import '../../../models/primary models/user_profile_model.dart';
import '../player_controller.dart';
import '../../../models/secundary models/devices.dart';
import 'device_tile.dart';

import 'package:flutter/material.dart';

class DevicesDialog extends StatefulWidget {
  const DevicesDialog({super.key});

  @override
  State<DevicesDialog> createState() => _DevicesDialogState();
}

class _DevicesDialogState extends State<DevicesDialog> {
  List<Devices> devicesList = [];
  PlayerController playlistController = PlayerController.instance;

  getCurrentDevices() {
    playlistController.getAvailableDevices().then((data) {
      if (mounted) {
        setState(() {
          devicesList = data;
        });
      }
    });
  }

  @override
  void initState() {
    getCurrentDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool freeUser = (UserProfile.instance.product ?? 'free') == 'free';
    return SimpleDialog(
      children: [
        SizedBox(
          height: 400,
          width: 300,
          child: ListView.builder(
            itemCount: devicesList.length,
            itemBuilder: (context, index) {
              return SimpleDialogOption(
                child: Column(
                  children: [
                    IgnorePointer(
                      ignoring: freeUser,
                      child: DeviceTile(
                        deviceName: devicesList[index].name ?? '',
                        deviceType: devicesList[index].type ?? '',
                        active: devicesList[index].isActive ?? false,
                        onTap: () {
                          playlistController
                              .transferPlayback(devicesList[index].id)
                              .then((_) {
                            if (mounted) {
                              getCurrentDevices();
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
