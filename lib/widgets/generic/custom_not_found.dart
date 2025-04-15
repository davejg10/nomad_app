import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomNotFound extends StatelessWidget {
  final String thingNotFound;
  final IconData iconData;

  const CustomNotFound({
    super.key,
    required this.thingNotFound,
    this.iconData = Icons.explore_off_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final randomRotation = (math.Random().nextDouble() - 0.5) * 0.05;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: randomRotation,
              child:
                Icon(
                  iconData,
                  size: 100.0,
                  color: colorScheme.secondary.withOpacity(0.7),
                ),
            ),
            const SizedBox(height: 24.0),

            Text(
              "Lost in Transit?",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12.0),

            // --- Specific Message ---
            Text(
              "Looks like our map for '${thingNotFound.toLowerCase()}' is currently blank. Maybe they took a detour?",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant, // Slightly less prominent color
                height: 1.4, // Improve readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}