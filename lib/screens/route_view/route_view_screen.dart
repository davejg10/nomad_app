import 'package:flutter/material.dart';
import 'package:nomad/widgets/screen_scaffold.dart';
import 'package:nomad/screens/route_view/widgets/itinerary_totals_bar.dart';

import '../../constants.dart';
import '../../domain/city.dart';
import '../../domain/country.dart';
import 'widgets/itinerary_sliver_view.dart';

class RouteViewScreen extends StatelessWidget {
  const RouteViewScreen(
      {super.key, required this.country, required this.routeList});

  final Country country;
  final List<City> routeList;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBar: AppBar(
        title: Text(
          country.getName,
          style: TextStyle(
              fontSize: 40,
              fontWeight: kFontWeight
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              // decoration: kSunkenBoxDecoration,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ItineraryTotalsBar(routeList: routeList),
                  ItinerarySliverView(routeList: routeList)
                ],
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}