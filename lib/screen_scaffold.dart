import 'package:flutter/material.dart';

import 'constants.dart';

class ScreenScaffold extends StatelessWidget {
  ScreenScaffold({super.key, this.appBar, required this.child, this.padding});

  AppBar? appBar;
  Widget child;
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: padding == null ?  kSidePadding : padding!,
          child: child,
        ),
      ),
    );
  }
}
