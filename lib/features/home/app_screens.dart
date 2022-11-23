import 'package:animations/animations.dart';
import 'package:colab_helper_for_spotify/features/home/home_page.dart';
import 'package:flutter/material.dart';

class AppScreens extends StatefulWidget {
  const AppScreens({super.key});

  @override
  State<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends State<AppScreens> {
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
