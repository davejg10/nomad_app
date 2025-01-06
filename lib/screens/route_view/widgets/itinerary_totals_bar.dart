import 'package:flutter/material.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/route_metric.dart';
import 'package:nomad/screens/route_view/widgets/route_section_title.dart';
import 'package:nomad/widgets/city_rating.dart';
import 'package:nomad/widgets/route_aggregate_card.dart';
import 'package:nomad/widgets/route_total_metric.dart';

class ItineraryTotalsBar extends StatelessWidget {
  const ItineraryTotalsBar({
    super.key,
    required this.routeList
  });

  final List<City> routeList;

  @override
  Widget build(BuildContext context) {
    // Using SliverAppBar allows us to create the custom animation of having the route aggregates
    // float and be snapped back to UI if user scrolls back up
    return SliverAppBar(
      automaticallyImplyLeading: false, // Remove navigation arrow
      primary: false, // Already using a navbar
      expandedHeight: 210,
      pinned: false,
      scrolledUnderElevation: 16.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const RouteSectionTitle(
                        title: 'Route totals'),
                    Center(
                      child: RouteAggregateCard(
                        columnChildren: [
                          RouteTotalMetric(
                              metric: RouteMetric.WEIGHT.name,
                              metricTotal: routeList.length
                                  .toDouble()),
                          RouteTotalMetric(
                              metric: RouteMetric.COST.name,
                              metricTotal: routeList.length
                                  .toDouble()),
                          RouteTotalMetric(
                              metric: RouteMetric.POPULARITY.name,
                              metricTotal: routeList.length
                                  .toDouble())
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const RouteSectionTitle(
                        title: 'City averages'),
                    RouteAggregateCard(
                      columnChildren: [
                        ...CityCriteria.values.map((criteria) {
                          return Expanded(child: CityRating(
                              score: City.calculateAggregateScore(
                                  criteria, routeList),
                              ratingIcon: City
                                  .convertCriteriaToIcon(
                                  criteria)));
                        }).toList()
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
