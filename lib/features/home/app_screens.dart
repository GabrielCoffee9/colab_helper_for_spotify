// ignore_for_file: use_build_context_synchronously

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
    AuthController().connectionStatus.listen((data) {
      if (!data.connected && !showingSync) {
        showingSync = true;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SyncingSpotify();
          },
        );
      } else {
        if (showingSync) {
          Navigator.of(context).pop();
        }
      }
    });

    super.initState();
  }

  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    const HomePage(),
    Scaffold(
        appBar: AppBar(
          title: const Text('Add Page'),
        ),
        body: const SizedBox(child: Text('Page 2'))),
    Scaffold(
        appBar: AppBar(
          title: const Text('Social Page'),
        ),
        body: const SizedBox(child: Text('Page 3'))),
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
