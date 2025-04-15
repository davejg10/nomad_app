import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';

class CityAvailableRoutesCardRow extends StatelessWidget {
  const CityAvailableRoutesCardRow({
    super.key,
    required this.route
  });
  final Neo4jRoute route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: route.getTransportType.getColor().withOpacity(0.1),
          borderRadius: kContainerShape,
        ),
        child: Padding(
          padding: kCardPadding,
          child: Row(
            children: [
              // Transport mode icon
              Container(
                decoration: BoxDecoration(
                  color: route.getTransportType.getColor(),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  route.getTransportType.getIcon(),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Text(
                  route.getTransportType.getName(),
                  style: kSubHeaderTextStyle,
                ),
              ),

              // Average duration
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: kStandardIconSize, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${route.getAverageDuration.inHours} hrs',
                      style: kNormalTextStyle,
                    ),
                  ],
                ),
              ),

              // Average cost
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.attach_money, size: kStandardIconSize, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '£${route.getAverageCost.toStringAsFixed(2)}',
                      style: kSubHeaderTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
