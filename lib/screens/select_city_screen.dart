import 'package:flutter/material.dart';
import 'package:nomad/screens/route_view_screen.dart';
import 'package:nomad/widgets/scrollable_bottom_sheet.dart';

import '../constants.dart';
import '../data/destination_respository.dart';
import '../domain/city.dart';
import '../domain/country.dart';
import '../domain/route_metric.dart';
import '../screen_scaffold.dart';
import '../widgets/city_list_view.dart';
import '../widgets/route_aggregate_card.dart';
import '../widgets/route_summary.dart';
import 'city_details_screen.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key, required this.country});

  final Country country;

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool searchBarOpen = false;

  List<City> routeList = [];
  late List<City> remainingCityList;
  late List<City> queriedCityList;

  @override
  void initState() {
    super.initState();
    // In future this will be a network request to request all recommended cities from routeList.last();
    ensureDisjointLists();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void closeSearchBar() {
    _searchController.text = '';
    _focusNode.unfocus();
    searchBarOpen = false;
  }

  void ensureDisjointLists() {
    remainingCityList = scopedCities.where((city) => !routeList.contains(city)).toList();
    queriedCityList = remainingCityList;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero, //Allows ScrollSheet to be full width of screen
        appBar: AppBar(
        title: Text(
          widget.country.getName,
          style: kAppBarTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: routeList.isNotEmpty ? () {
              setState(() {
                routeList.removeLast();
                ensureDisjointLists();
              });
            } : null,
          ),
          if (searchBarOpen == false)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchBarOpen = true;
                  _focusNode.requestFocus();
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.task_alt),
            onPressed: routeList.isNotEmpty ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      RouteViewScreen(country: widget.country, routeList: routeList,),
                ),
              );
            } : null,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: kSidePadding,
            child: Column(
              children: [
                if (searchBarOpen)
                  Flexible(
                    flex: 0, // Required to allow CityListView below to take up all remaining space
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: SearchBar(
                        onSubmitted: (userInput) {
                          List<City> possibleValidCity = scopedCities.where((city) => city.getName.toLowerCase() == userInput.trim().toLowerCase()).toList();
                          bool validCityInput = possibleValidCity.isNotEmpty;

                          if (validCityInput) {
                            setState(() {
                              closeSearchBar();
                              routeList = [...routeList, possibleValidCity.first];
                              ensureDisjointLists();
                            });
                          } else {
                            // TODO add popup diaglogue
                          }
                        },
                        onChanged: (userInput) {
                          setState(() {
                            String sanitizedUserInput = userInput.trim().toLowerCase();
                            queriedCityList = remainingCityList.where((city) => city.getName.toLowerCase().contains(sanitizedUserInput)).toList();
                          });
                        },
                        controller: _searchController,
                        focusNode: _focusNode,
                        hintText: 'Search cities...',
                        leading: Icon(Icons.search),
                        trailing: [IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              closeSearchBar();
                            });
                          },
                        ),]
                      ),
                    ),
                  ),
                Expanded(
                  child: CityListView(
                    cityList: queriedCityList,
                    cardOnTap: (City selectedCity) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CityDetailsScreen(selectedCity: selectedCity),
                        ),
                      );
                    },
                    arrowIconOnTap: (City selectedCity) {
                      setState(() {
                        closeSearchBar();
                        routeList = [...routeList, selectedCity];
                        ensureDisjointLists();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ScrollableBottomSheet(
            sheetContent:  [
              RouteSummary(routeList: routeList),
              RouteAggregateCard(
                boxConstraints: BoxConstraints(maxHeight: 100, maxWidth: 125),
                columnChildren: [
                  RouteTotalMetric(metric: RouteMetric.WEIGHT.name, metricTotal: routeList.length.toDouble()),
                  RouteTotalMetric(metric: RouteMetric.COST.name, metricTotal: routeList.length.toDouble()),
                  RouteTotalMetric(metric: RouteMetric.POPULARITY.name, metricTotal: routeList.length.toDouble())
                ],
              )
            ],
          )
        ],
      )
    );
  }
}

