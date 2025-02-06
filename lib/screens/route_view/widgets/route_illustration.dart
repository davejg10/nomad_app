import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/domain/route_metric.dart';

class RouteIllustration extends StatelessWidget {
  const RouteIllustration({
    super.key,
    required this.routeEntity,
  });
  final RouteEntity routeEntity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Symbols.south,
          weight: 150,
          size: 80,
          opticalSize: 6.0,
          fill: 1,
        ),
        Positioned(right: 60, child: Column(
          children: [
            Text('(${routeEntity.getTransportType.name})'),
            Text('${RouteMetric.TIME.name}(${routeEntity.getTime})'),
            Text('${RouteMetric.POPULARITY.name}(${routeEntity.getPopularity})'),
          ],
        ))
      ],
    );
  }
}
