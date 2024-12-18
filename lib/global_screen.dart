import 'package:flutter/material.dart';

class GlobalScreen extends StatelessWidget {
  GlobalScreen({super.key, this.appBar, required this.child});

  AppBar? appBar;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: child,
        ),
      ),
    );
  }
}
