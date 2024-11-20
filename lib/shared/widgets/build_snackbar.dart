import '../modules/appLocalizations/localizations_controller.dart';

import 'package:flutter/material.dart';

void buildSnackBar(BuildContext context, {String? error}) {
  return WidgetsBinding.instance.addPostFrameCallback(
    (_) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
        content: Text(
          error ?? (LocalizationsController.of(context)!.errorCheckConnection),
        ),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      ),
    ),
  );
}
