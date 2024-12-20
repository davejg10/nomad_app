import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nomad/domain/route_metric.dart';
import 'package:nomad/screen_scaffold.dart';
import 'package:nomad/widgets/city_card.dart';
import 'package:nomad/widgets/route_aggregate_card.dart';

import '../constants.dart';
import '../domain/city.dart';
import '../domain/city_criteria.dart';
import '../domain/country.dart';
import '../widgets/city_rating.dart';
import 'city_details_screen.dart';

class RouteViewScreen extends StatelessWidget {
  const RouteViewScreen({super.key, required this.country, required this.routeList});

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
              decoration: kSunkenBoxDecoration,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Using SliverAppBar allows us to create the custom animation of having the route aggregates
                  // float and be snapped back to UI if user scrolls back up
                  SliverAppBar(
                    automaticallyImplyLeading: false, // Remove navigation arrow
                    primary: false, // Already using a navbar
                    expandedHeight: 210,
                    pinned: false,
                    floating: true,
                    snap: true,
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
                                  const RouteSectionTitle(title: 'Route totals'),
                                  Center(
                                    child: RouteAggregateCard(
                                      columnChildren: [
                                        RouteTotalMetric(metric: RouteMetric.WEIGHT.name, metricTotal: routeList.length.toDouble()),
                                        RouteTotalMetric(metric: RouteMetric.COST.name, metricTotal: routeList.length.toDouble()),
                                        RouteTotalMetric(metric: RouteMetric.POPULARITY.name, metricTotal: routeList.length.toDouble())
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const RouteSectionTitle(title: 'City averages'),
                                  RouteAggregateCard(
                                    columnChildren: [
                                      ...CityCriteria.values.map((criteria ) {
                                        return Expanded(child: CityRating(score: City.calculateAggregateScore(criteria, routeList), ratingIcon: City.convertCriteriaToIcon(criteria)));
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
                  ),
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

class ItinerarySliverView extends StatefulWidget {
  const ItinerarySliverView({super.key, required this.routeList});

  final List<City> routeList;

  @override
  State<ItinerarySliverView> createState() => _ItinerarySliverViewState();
}

class _ItinerarySliverViewState extends State<ItinerarySliverView> {

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
        itemCount: widget.routeList.length,
        itemBuilder: (context, index) {
          City city = widget.routeList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CityCard(
                key: Key('cityCard${city.getName}'),
                city: city,
                trailingIcon: Symbols.close,
                cardOnTap: (City selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CityDetailsScreen(selectedCity: selectedCity),
                    ),
                  );
                },
                arrowIconOnTap: (City selectedCity) {
                  setState(() {
                    widget.routeList.remove(selectedCity);
                  });
                }
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Symbols.south,
                weight: 150,
                size: 80,
                opticalSize: 6.0,
                fill: 1,
              ),
              Positioned(right: 110, child: Text('WEIGHT(1)'))
            ],
          );
        }
    );
  }
}


class RouteSectionTitle extends StatelessWidget {
  const RouteSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

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

