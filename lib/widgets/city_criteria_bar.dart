import 'package:flutter/material.dart';
import 'package:nomad/domain/city_criteria.dart';

class CityCriteriaBar extends StatelessWidget {
  const CityCriteriaBar({
    super.key,
    required this.cityCriteria,
    required this.metric
  });

  final CityCriteria cityCriteria;
  final double metric;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              cityCriteria.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: metric / 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getRankingColor(metric),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '$metric/10',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Color for ranking based on score
  Color _getRankingColor(double metric) {
    if (metric >= 8) return Colors.green;
    if (metric >= 5) return Colors.orange;
    return Colors.red;
  }
}
