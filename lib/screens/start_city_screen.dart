import 'package:flutter/material.dart';

import '../domain/city.dart';
import '../domain/country.dart';

class StartCityScreen extends StatelessWidget {
  const StartCityScreen({super.key, required this.country});

  final Country country;

  List<City> getCityList(String countryName) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  child: Text(country.getName),
              ),
            ),
          ),
          ListView()
        ],
      ),
    );
  }
}

class CityListView extends StatelessWidget {
  CityListView({super.key, required this.cityList});

  List<City> cityList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cityList.length,
        itemBuilder: itemBuilder
    );
  }
}

