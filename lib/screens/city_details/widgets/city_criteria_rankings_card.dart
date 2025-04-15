import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/widgets/city_criteria_bar.dart';

class CityCriteriaRankingsCard extends StatelessWidget {
  const CityCriteriaRankingsCard({
    super.key,
    required this.selectedCity
  });

  final Neo4jCity selectedCity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: kCardMargin,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: kCardBorderRadius,
      ),
      child: Padding(
        padding: kCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'City Rankings',
              style: kHeaderTextStyle,
            ),
            Divider(),
            SizedBox(height: 10),
            // Sailing, Nightlife, Food Rankings
            ...selectedCity.getCityRatings.entries.map((entry) {
              return CityCriteriaBar(
                  cityCriteria: entry.key,
                  metric: entry.value
              );
            }),

          ],
        ),
      ),
    );
  }
}
