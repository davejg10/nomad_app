import 'package:flutter/material.dart';

class RouteSectionTitle extends StatelessWidget {
  const RouteSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}