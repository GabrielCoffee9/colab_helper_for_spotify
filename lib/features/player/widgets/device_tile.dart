import 'package:flutter/material.dart';

const devicesIconList = {
  "Smartphone": Icons.smartphone_outlined,
  "Computer": Icons.computer_outlined
};

class DeviceTile extends StatelessWidget {
  const DeviceTile(
      {super.key,
      required this.deviceName,
      required this.deviceType,
      required this.active,
      required this.onTap});

  final String deviceType;
  final String deviceName;
  final bool active;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Icon(devicesIconList[deviceType]),
        title: Text(deviceName),
        subtitle: active ? Text('Current device') : Text('Not playing'),
        selected: active,
        onTap: onTap,
      ),
    );
  }
}
