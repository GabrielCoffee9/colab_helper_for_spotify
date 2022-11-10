import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/shared/modules/user/user_controller.dart';
import 'package:colab_helper_for_spotify/shared/static/color_schemes.g.dart';
import 'package:colab_helper_for_spotify/shared/widgets/app_logo.dart';
import 'package:colab_helper_for_spotify/shared/widgets/circular_progress.dart';
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
      if (widget.authController.state.value == AuthState.loading) {
        buttonState = ButtonState.loading;
        setState(() {});
      }

      if (widget.authController.state.value == AuthState.error) {
        buttonState = ButtonState.idle;
        setState(() {
          buildSnackBar(context);
        });
      }
    });

    widget.userController.state.addListener(() {
      if (widget.userController.state.value == UserState.error) {
        setState(() {
          buttonState = ButtonState.idle;
          buildSnackBar(context);
        });
      }

      if (widget.authController.state.value == AuthState.idle &&
          widget.userController.state.value == UserState.success) {
        widget.userController.state.value = UserState.idle;

        setState(() {
          buttonState = ButtonState.done;
        });

        Future.delayed(const Duration(seconds: 1))
            .then((value) => Navigator.popAndPushNamed(context, '/app'));
      }
    });
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
                Image.asset("lib/assets/Spotify_Logo_RGB_Green.png"),
                const SizedBox(
                  height: 120,
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: buttonState == ButtonState.idle
                      ? ElevatedButton(
                          onPressed: () async {
                            if (await widget.authController.verifySync()) {
                              await widget.userController.getUserProfile();
                            }
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

void buildSnackBar(BuildContext context) {
  return WidgetsBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content:
                const Text('Error! Check your connection and try again later.'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          )));
}
