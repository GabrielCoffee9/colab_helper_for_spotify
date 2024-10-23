import 'app_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return SafeArea(
        child: SingleChildScrollView(
          key: const Key('ErrorScreen'),
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 50),
                child: Text(
                    'If you are seeing this screen, your app/page crashed 😥'),
              ),
              SelectableText(
                '${details.exception}\n${details.library}\n${details.stack}',
                maxLines: null,
              ),
            ],
          ),
        ),
      );
    };
  }

  runApp(const ColabApp());
}
