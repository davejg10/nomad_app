import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/destination_respository.dart';
import '../domain/city.dart';
import '../domain/country.dart';
import '../global_screen.dart';
import '../widgets/city_list_view.dart';
import '../widgets/route_aggregate_card.dart';
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
    // In future this will be a network request to request all recommended cities from widget.routeList.last();
    remainingCityList = scopedCities;
    queriedCityList = remainingCityList;

    _searchController.addListener(() {
      String userInput = _searchController.text.toLowerCase().trim();
      setState(() {
        queriedCityList = remainingCityList.where((city) => city.getName.toLowerCase().contains(userInput)).toList();
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScreen(
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
                remainingCityList = scopedCities.where((city) => !routeList.contains(city)).toList();
                queriedCityList = remainingCityList;
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
            )
        ],
      ),
      child: Column(
        children: [
          if (searchBarOpen)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: SearchBar(
                    controller: _searchController,
                    focusNode: _focusNode,
                    hintText: 'Search...',
                    leading: Icon(Icons.search),
                    trailing: [IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          searchBarOpen = false;
                        });
                      },
                    ),]
                ),
              ),
            ),
          Expanded(
            flex: 5,
            child: CityListView(
              cityList: queriedCityList,
              cardOnTap: (City selectedCity) {
                setState(() {
                  _searchController.text = '';
                  _focusNode.unfocus();
                  searchBarOpen = false;
                  routeList = [...routeList, selectedCity];
                  // In future this will return a totally new list in which cities relating to the chosen city are returned.
                  remainingCityList = scopedCities.where((city) => !routeList.contains(city)).toList();
                  queriedCityList = remainingCityList;
                });
              },
              arrowIconOnTap: (City selectedCity) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CityDetailsScreen(selectedCity: selectedCity),
                  ),
                );
              },
            ),
          ),
          if (routeList.isNotEmpty) ...[
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route summary:',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [Text(
                          routeList.map((city) => city.getName).join(' -> '),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15.0),
                        )],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: RouteAggregateCard(),
            ),
          ]
        ],
      )
    );
  }
}
