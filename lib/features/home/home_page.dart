import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final controller = context.read<UserController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (() {}), child: const Icon(Icons.add)),
      body: SafeArea(
        child: Column(
          children: [
            Text('Welcome ${controller.userProfile.displayName!}'),
            Center(
              child: controller.userProfile.images?.first.url == null
                  ? const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 36,
                        color: Colors.black,
                      ))
                  : CircleAvatar(
                      radius: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.network(
                            controller.userProfile.images?.first.url ?? ''),
                      )),
            )
          ],
        ),
      ),
    );
  }
}
