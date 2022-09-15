import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';
import 'package:colab_helper_for_spotify/shared/static/color_schemes.g.dart';
import 'package:colab_helper_for_spotify/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ButtonState { init, loading, done }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  ButtonState buttonState = ButtonState.init;

  late final AuthController controller;
  late final UserController userController;
  @override
  void initState() {
    super.initState();

    controller = context.read<AuthController>();
    userController = context.read<UserController>();
    controller.addListener(() {
      if (controller.state == AuthState.error) {
        controller.state = AuthState.idle;
        buttonState = ButtonState.init;

        WidgetsBinding.instance.addPostFrameCallback((_) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 30),
              content: const Text('Error at Authentication, try again later.'),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {},
              ),
            )));
      }
    });

    userController.addListener(() {
      if (userController.state == UserState.error) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 30),
                  content: const Text(
                      'Error! Check your connection and try again later.'),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () {},
                  ),
                )));
      }

      if (userController.state == UserState.loading) {
        buttonState = ButtonState.loading;
      } else {
        buttonState = ButtonState.init;
      }

      if (controller.state == AuthState.idle &&
          userController.state == UserState.success) {
        userController.state = UserState.idle;
        buttonState = ButtonState.init;
        Navigator.popAndPushNamed(context, '/app');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    final userController = context.watch<UserController>();
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    final isDone = buttonState == ButtonState.init;
    final buttonType = buttonState == ButtonState.init;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                AppLogo(iconSize: 150, darkTheme: isDarkMode),
                const Text(
                  'Colab Helper For ',
                  style: TextStyle(fontSize: 36),
                ),
                Image.asset("lib/assets/Spotify_Logo_RGB_Green.png"),
                const SizedBox(
                  height: 110,
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: buttonType
                      ? ElevatedButton(
                          onPressed: () async {
                            await controller.verifySync();
                            await userController.getCurrentUserProfile();
                          },
                          child: const Text('Sync account'),
                        )
                      : buidCircularProgress(
                          isDarkMode
                              ? darkColorScheme.onPrimary
                              : lightColorScheme.onPrimary,
                          isDarkMode
                              ? darkColorScheme.primary
                              : lightColorScheme.primary,
                          isDone),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buidCircularProgress(Color backgroundColor, circularColor, bool isDone) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
    child: Center(
      child: isDone
          ? Icon(
              Icons.done,
              size: 52,
              color: circularColor,
            )
          : CircularProgressIndicator(
              color: circularColor,
            ),
    ),
  );
}
