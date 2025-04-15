import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';

class IconBackgroundButton extends StatelessWidget {
  IconBackgroundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.padding,
    this.backgroundColor,
    this.iconColor
  });

  final IconData icon;
  final VoidCallback onPressed;
  EdgeInsetsGeometry? padding;
  Color? backgroundColor;
  Color? iconColor;

  @override
  Widget build(BuildContext context) {
    Color _cardColor = backgroundColor ?? Theme.of(context).colorScheme.secondary ?? Colors.white;
    Color _iconColor = iconColor ?? Theme.of(context).buttonTheme.colorScheme!.onPrimary ;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Card(
        elevation: kIconButtonElevation,
        shape: kButtonShape,
        color: _cardColor,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: _iconColor,
        ),
      ),
    );
  }
}
