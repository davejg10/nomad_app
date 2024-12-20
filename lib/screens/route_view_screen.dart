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
            style: kAppBarTextStyle,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'ROUTE DETAILS',
              style: TextStyle(
                fontSize: 30,
                fontWeight: kFontWeight
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const RouteSectionTitle(title: 'Route totals'),
                    Container(
                      width: 170,
                      height: 180,
                      decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black,
                            ),
                            const BoxShadow(
                              color: Color(0xFF1D1E33),
                              spreadRadius: -2.0,
                              blurRadius: 8.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: Center(
                        child: RouteAggregateCard(
                          columnChildren: [
                            RouteTotalMetric(metric: RouteMetric.WEIGHT.name, metricTotal: routeList.length.toDouble()),
                            RouteTotalMetric(metric: RouteMetric.COST.name, metricTotal: routeList.length.toDouble()),
                            RouteTotalMetric(metric: RouteMetric.POPULARITY.name, metricTotal: routeList.length.toDouble())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const RouteSectionTitle(title: 'City averages'),
                    Container(
                      width: 170,
                      height: 180,
                      decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black,
                            ),
                            const BoxShadow(
                              color: Color(0xFF1D1E33),
                              spreadRadius: -2.0,
                              blurRadius: 8.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: Center(
                        child: RouteAggregateCard(
                          columnChildren: [
                            ...CityCriteria.values.map((criteria ) {
                              return Expanded(child: CityRating(score: City.calculateAggregateScore(criteria, routeList), ratingIcon: City.convertCriteriaToIcon(criteria)));
                            }).toList()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30,),
            const RouteSectionTitle(title: 'Itinerary'),
            Expanded(
              flex: 3,
              child: ItineraryListView(routeList: routeList)
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
class ItineraryListView extends StatefulWidget {
  const ItineraryListView({super.key, required this.routeList});

  final List<City> routeList;

  @override
  State<ItineraryListView> createState() => _ItineraryListViewState();
}

class _ItineraryListViewState extends State<ItineraryListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black,
            ),
            const BoxShadow(
              color: Color(0xFF1D1E33),
              spreadRadius: -2.0,
              blurRadius: 8.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: ListView.separated(
          itemCount: widget.routeList.length,
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
          },
          itemBuilder: (context, index) {
            City city = widget.routeList[index];
            return CityCard(
                key: Key('cityCard${city.getName}'),
                city: city,
                cardOnTap: (_) {},
                arrowIconOnTap: (selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CityDetailsScreen(selectedCity: selectedCity),
                    ),
                  );
                }
            );
          }
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

