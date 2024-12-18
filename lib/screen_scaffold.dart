import 'package:flutter/material.dart';

import 'constants.dart';

class ScreenScaffold extends StatelessWidget {
  ScreenScaffold({super.key, this.appBar, required this.child});

  AppBar? appBar;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: kSidePadding,
          child: child,
        ),
      ),
    );
  }
}
