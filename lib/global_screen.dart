import 'package:flutter/material.dart';

class GlobalScreen extends StatelessWidget {
  GlobalScreen({super.key, required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: child,
        ),
      ),
    );
  }
}
