import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../domain/city.dart';

class RouteSummary extends StatelessWidget {
  RouteSummary({super.key, required this.routeList});

  final List<City> routeList;
  final ScrollController _scrollbarController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route summary:',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: kFontWeight,
            ),
          ),
          Container(
            height: 30,
            child: Scrollbar(
              controller: _scrollbarController,
              thumbVisibility: true,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _scrollbarController,
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