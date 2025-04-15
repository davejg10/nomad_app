import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';

class TextBackgroundButton extends StatelessWidget {
  TextBackgroundButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.elevation = 2,
    this.backgroundColor,
    this.textColor
  });

  final String text;
  final VoidCallback onPressed;
  double elevation;
  Color? backgroundColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color cardColor = backgroundColor ?? Theme.of(context).colorScheme.secondary;
    Color _textColor = textColor ?? Theme.of(context).colorScheme.onSecondary;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: kButtonShape,
        padding: kButtonPadding,
        backgroundColor: cardColor,
        elevation: 1

      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textColor
        ),
      ),
    );
  }
}
