import 'package:flutter/material.dart';

import '../domain/city.dart';

class RouteAggregateCard extends StatelessWidget {
  const RouteAggregateCard({super.key, required this.routeList});

  final List<City> routeList;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        elevation: 8.0,
        color: Colors.white54,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WEIGHT - ${routeList.length}',
              ),
              Text(
                'COST - ${routeList.length}'
              ),
              Text(
                'POPULARITY - ${routeList.length}',
              )
            ],
          ),
        ),
      ),
    );
  }
}
