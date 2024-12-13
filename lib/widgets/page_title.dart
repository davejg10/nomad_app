import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.titleText});

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Text(
            titleText.toUpperCase(),
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}
