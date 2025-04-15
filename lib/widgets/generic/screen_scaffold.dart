import 'package:flutter/material.dart';

import '../../constants.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundColor,
    this.padding = kSidePadding});

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor = backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHigh;
    return Scaffold(
      appBar: appBar,
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: padding,
        child: child
      ),
    );
  }
}
