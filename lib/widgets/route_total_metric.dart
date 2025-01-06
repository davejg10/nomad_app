import 'package:flutter/material.dart';

import '../constants.dart';

class RouteTotalMetric extends StatelessWidget {
  const RouteTotalMetric({super.key, required this.metric, required this.metricTotal});

  final String metric;
  final double metricTotal;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        '$metric - $metricTotal',
        style: const TextStyle(
            fontWeight: kFontWeight
        ),
      ),
    );
  }
}