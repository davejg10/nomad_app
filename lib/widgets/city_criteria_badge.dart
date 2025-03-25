import 'package:flutter/material.dart';
import 'package:nomad/domain/city_criteria.dart';

class CityCriteriaBadge extends StatelessWidget {

  const CityCriteriaBadge({
    Key? key,
    required this.cityCriteria,
    required this.metric,
    this.threshold = 9 ,// Show badge for scores of 9 or 10 by default
    this.screen = "CityDetails"
  }) : super(key: key);

  final CityCriteria cityCriteria;
  final double metric;
  final int threshold;
  final String screen;

  @override
  Widget build(BuildContext context) {
    // Only show badge if score meets or exceeds threshold
    if (metric < threshold && screen != "CityDetails") {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getColorForBadge(metric).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _getColorForBadge(metric), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            cityCriteria.convertCriteriaToIcon(),
            color: _getColorForBadge(metric),
            size: 16.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            cityCriteria.name,
            style: TextStyle(
              color: _getColorForBadge(metric),
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(width: 4.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: _getColorForBadge(metric),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              '$metric',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForBadge(double metric) {
    switch (metric) {
      case 10:
        return Colors.green;
      case 9:
        return Colors.green;
      case 8:
        return Colors.green;
      case 7:
        return Colors.orange;
      case 6:
        return Colors.orange;
      case 5:
        return Colors.yellow;
      case 4:
        return Colors.yellow;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.red;
      case 1:
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}