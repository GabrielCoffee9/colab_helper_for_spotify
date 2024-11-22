import '../../shared/widgets/syncing_spotify.dart';
import '../auth/auth_controller.dart';
import '../player/player_controller.dart';
import '../player/player_bottom_sheet.dart';
import 'home_page.dart';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
  PlayerController playerController = PlayerController.instance;
  bool showingSync = false;
  @override
  void initState() {
    super.initState();

    AuthController.instance.connectionStatus.listen((data) {
      if (!data.connected && !showingSync && mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const SyncingSpotify();
          },
        );
        showingSync = true;
      } else {
        if (showingSync && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showingSync = false;
        }
      }
    });
  }

  int pageIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> pageList = <Widget>[
    const HomePage(),
    Scaffold(
        appBar: AppBar(
          title: const Text('Add'),
        ),
        body: const SizedBox()),
    Scaffold(
        appBar: AppBar(
          title: const Text('Social'),
        ),
        body: const SizedBox()),
  ];
  @override
  Widget build(BuildContext context) {
    final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      bottomSheet: keyboardVisibility ? null : const PlayerBottomSheet(),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerController.miniPlayerDisplay,
        builder: (context, value, child) {
          return NavigationBar(
            height: (80 - value),
            selectedIndex: pageIndex,
            onDestinationSelected: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            destinations: const [
              NavigationDestination(
                  label: 'Home', icon: Icon(Icons.home_outlined)),
              NavigationDestination(
                  label: 'Add', icon: Icon(Icons.add_circle_outline)),
              NavigationDestination(
                  icon: Icon(Icons.contacts_outlined), label: 'Social'),
            ],
          );
        },
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: ((child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            )),
        child: IndexedStack(
          index: pageIndex,
          children: [
            _buildNavigator(0, const HomePage()),
            _buildNavigator(
              1,
              Scaffold(
                  appBar: AppBar(
                    title: const Text('Add'),
                  ),
                  body: const SizedBox()),
            ),
            _buildNavigator(
                2,
                Scaffold(
                    appBar: AppBar(
                      title: const Text('Social'),
                    ),
                    body: const SizedBox())),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
