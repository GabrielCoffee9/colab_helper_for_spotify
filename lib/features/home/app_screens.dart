import '../../shared/widgets/syncing_spotify.dart';
import '../auth/auth_controller.dart';
import 'home_page.dart';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
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
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: pageIndex,
        onDestinationSelected: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home_outlined)),
          NavigationDestination(
              label: 'Add', icon: Icon(Icons.add_circle_outline)),
          NavigationDestination(
              icon: Icon(Icons.contacts_outlined), label: 'Social'),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: ((child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            )),
        child: pageList[pageIndex],
      ),
    );
  }
}
