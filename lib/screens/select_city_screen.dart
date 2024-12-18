import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/destination_respository.dart';
import '../domain/city.dart';
import '../domain/country.dart';
import '../screen_scaffold.dart';
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
    ensureDisjointLists();

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
            flex: 5,
            child: CityListView(
              cityList: queriedCityList,
              cardOnTap: (City selectedCity) {
                setState(() {
                  closeSearchBar();
                  routeList = [...routeList, selectedCity];
                  ensureDisjointLists();
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
          PopModal(routeList: routeList,),

        ],
      )
    );
  }
}

class PopModal extends StatelessWidget {
  PopModal({super.key, required this.routeList});
  
  final List<City> routeList;

  BorderRadiusGeometry curvedEdges = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        Scaffold.of(context).showBottomSheet((BuildContext scaffoldContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: curvedEdges,
            ),
            height: 200,
            child: Padding(
              padding: kSidePadding,
              child: Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.drag_handle,
                    ),
                  ),
                  RouteSummary(routeList: routeList),
                  RouteAggregateCard(routeList: routeList),
                ],
              ),
            ),
          );
        });
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: curvedEdges,
        ),
        child:
        Center(
          child: Icon(
            Icons.drag_handle,
          ),
        ),
      ),
    );
  }
}

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
    );
  }
}