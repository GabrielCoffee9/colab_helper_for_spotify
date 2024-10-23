import '../../shared/modules/user/user_controller.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/circular_progress.dart';
import '../../shared/widgets/get_spotify.dart';
import 'auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';

enum ButtonState { idle, loading, done }

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  final AuthController authController = AuthController.instance;
  final UserController userController = UserController();

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  ButtonState buttonState = ButtonState.idle;

  Future<bool> checkSpotifyApp() async {
    return AppCheck().isAppInstalled('com.spotify.music');
  }

  void syncSpotify() {
    setState(() {
      buttonState = ButtonState.loading;
    });

    checkSpotifyApp().then((result) {
      if (result) {
        widget.authController.syncSpotifyRemote();
      } else {
        if (mounted) {
          setState(() {
            buttonState = ButtonState.idle;
          });
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return const GetSpotify();
            },
          );
        }
      }
    });
  }

  @override
  void initState() {
    widget.authController.connectionStatus.listen(
      (event) {
        if (event.connected) {
          if (mounted) {
            setState(() {
              buttonState = ButtonState.done;
            });
            Future.delayed(const Duration(seconds: 1)).then((_) =>
                mounted ? Navigator.popAndPushNamed(context, '/app') : null);
          }
        } else {
          if (mounted) {
            setState(() {
              buttonState = ButtonState.idle;
              buildSnackBar(
                context,
                error: event.message,
              );
            });
          }
        }
      },
    );

    syncSpotify();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                AppLogo(iconSize: 150, darkTheme: isDarkMode),
                const Text(
                  'Colab Helper For',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(
                  height: 40,
                ),
                Image.asset("lib/assets/Spotify_Logo_RGB_Green.png",
                    cacheWidth: 1038, cacheHeight: 311),
                const SizedBox(
                  height: 120,
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: buttonState == ButtonState.idle
                      ? ElevatedButton(
                          onPressed: () {
                            syncSpotify();
                          },
                          child: const Text('Sync account'),
                        )
                      : CircularProgress(
                          isDone: buttonState == ButtonState.done),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void buildSnackBar(BuildContext context, {String? error}) {
  return WidgetsBinding.instance.addPostFrameCallback(
    (_) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
        content: Text(
          error ?? ('Error! Check your connection and try again later.'),
        ),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      ),
    ),
  );
}
