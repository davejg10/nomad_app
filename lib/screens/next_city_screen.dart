import 'package:flutter/material.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/global_screen.dart';
import 'package:nomad/widgets/city_list_view.dart';

import '../domain/city.dart';
import '../widgets/route_aggregate_card.dart';
import 'city_details_screen.dart';

class NextCityScreen extends StatefulWidget {
  const NextCityScreen({super.key, required this.routeList});

  final List<City> routeList;

  @override
  State<NextCityScreen> createState() => _NextCityScreenState();
}

class _NextCityScreenState extends State<NextCityScreen> {

  final TextEditingController _searchController = TextEditingController();
  List<City> currentScopedList = [];
  List<City> filteredCityList = [];

  @override
  void initState() {
    super.initState();
    currentScopedList = scopedCities.where((city) => !widget.routeList.contains(city)).toList();
    filteredCityList = currentScopedList;

    _searchController.addListener(() {
      String userInput = _searchController.text.toLowerCase().trim();
      setState(() {
        filteredCityList = currentScopedList.where((city) => city.getName.toLowerCase().contains(userInput)).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScreen(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search...',
                leading: Icon(Icons.search),
              ),
            ),
            Expanded(
              flex: 5,
              child: CityListView(
                cityList: filteredCityList,
                cardOnTap: (City selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NextCityScreen(routeList: [...widget.routeList, selectedCity]),
                    ),
                  );
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
                          widget.routeList.map((city) => city.getName).join(' -> '),
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
          ],
        )
    );
  }
}

