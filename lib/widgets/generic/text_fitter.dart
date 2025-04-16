import 'package:flutter/material.dart';

class TextFitter extends StatelessWidget {
  const TextFitter({
    super.key,
    required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(text)
    );
  }
}
