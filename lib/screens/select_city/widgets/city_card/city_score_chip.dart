import 'package:flutter/material.dart';

class CityScoreChip extends StatelessWidget {
  final double score; // Score from 0-100
  final double size;

  const CityScoreChip({
    Key? key,
    required this.score,
    this.size = 28.0, // Adjust default size as needed
  }) : super(key: key);

  Color _getScoreColor(double score) {
    if (score < 10) {
      return Colors.red.shade400;
    } else if (score < 20) {
      return Colors.orange.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    // Use white text on darker/saturated colors, black on lighter ones
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _getScoreColor(score);
    final Color textColor = _getTextColor(bgColor);
    final double fontSize = size * 0.5; // Adjust font size relative to badge size

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.35, vertical: size * 0.15),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(size / 2), // Makes it a pill shape
          boxShadow: [ // Optional subtle shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: Offset(0, 1),
            )
          ]
      ),
      child: Text(
        score.toString(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
