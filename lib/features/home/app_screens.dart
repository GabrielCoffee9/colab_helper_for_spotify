import 'package:animations/animations.dart';
import 'package:colab_helper_for_spotify/features/home/home_page.dart';
import 'package:colab_helper_for_spotify/features/search/search_page.dart';
import 'package:colab_helper_for_spotify/shared/widgets/app_logo.dart';
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
    const SearchPage(),
    const Scaffold(body: SizedBox(child: Text('Page 3'))),
    const Scaffold(body: SizedBox(child: Text('Page 4'))),
  ];
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            setState(() {
              pageIndex = 0;
            });
          },
          child: AppLogo(
              iconSize: 32, darkTheme: colors.brightness == Brightness.dark),
        ),
      ),
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
              label: 'Search', icon: Icon(Icons.search_outlined)),
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
