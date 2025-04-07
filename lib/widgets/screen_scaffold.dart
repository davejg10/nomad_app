import 'package:flutter/material.dart';

import '../constants.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = kSidePadding});

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: child
        ),
      ),
    );
  }
}
