import 'package:flutter/material.dart';

class DrawerSide extends StatefulWidget {
  final Color color;
  const DrawerSide({super.key, required this.color});

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.amber,
        child: ListView(
          children: const [
            DrawerHeader(
              child: Column(
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
