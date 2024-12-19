import 'package:flutter/material.dart';

import '../domain/city.dart';

class RouteSummary extends StatelessWidget {
  const RouteSummary({super.key, required this.routeList});

  final List<City> routeList;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route summary:',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500
            ),
          ),
          Container(
            height: 30,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [Text(
                  routeList.map((city) => city.getName).join(' -> '),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.0),
                )],
              ),
            ),
          ),
        ],
      ),
    );
  }
}