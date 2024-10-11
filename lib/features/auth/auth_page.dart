import '../../shared/modules/user/user_controller.dart';
import '../../shared/static/color_schemes.g.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/circular_progress.dart';
import 'auth_controller.dart';

import 'package:flutter/material.dart';

enum ButtonState { idle, loading, done }

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  final AuthController authController = AuthController();
  final UserController userController = UserController();

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  ButtonState buttonState = ButtonState.idle;

  @override
  void initState() {
    super.initState();

    widget.authController.state.addListener(() {
      switch (widget.authController.state.value) {
        case AuthState.loading:
          setState(() {
            buttonState = ButtonState.loading;
          });

          break;

        case AuthState.error:
          setState(() {
            buttonState = ButtonState.idle;
            buildSnackBar(context, error: widget.authController.lastError);
          });
          break;

        case AuthState.success:
          widget.userController.getUserProfile();
          break;

        default:
          return;
      }
    });

    widget.userController.state.addListener(() {
      switch (widget.userController.state.value) {
        case UserState.error:
          setState(() {
            buttonState = ButtonState.idle;
            buildSnackBar(context, error: widget.userController.lastError);
          });

          break;
        case UserState.success:
          widget.userController.state.value = UserState.idle;
          setState(() {
            buttonState = ButtonState.done;
          });

          if (mounted) {
            Future.delayed(const Duration(seconds: 1))
                // ignore: use_build_context_synchronously
                .then((value) => Navigator.popAndPushNamed(context, '/app'));
          }
          break;

        default:
          return;
      }
    });

    widget.authController.syncSpotifyRemote();
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
                            widget.authController.syncSpotifyRemote();
                          },
                          child: const Text('Sync account'),
                        )
                      : CircularProgress(
                          backgroundColor: isDarkMode
                              ? darkColorScheme.onPrimary
                              : lightColorScheme.onPrimary,
                          circularColor: isDarkMode
                              ? darkColorScheme.primary
                              : lightColorScheme.primary,
                          isDone: buttonState == ButtonState.done,
                        ),
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
      (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
              error ?? ('Error! Check your connection and try again later.'),
            ),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          )));
}
