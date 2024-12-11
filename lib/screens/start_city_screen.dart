import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/screens/city_details_screen.dart';

import '../domain/city.dart';
import '../domain/country.dart';
import '../widgets/city_list_view.dart';
import 'next_city_screen.dart';

class StartCityScreen extends StatelessWidget {
  StartCityScreen({super.key, required this.country});

  final Country country;

  // Mock a DB query...
  List<City> getCityList(String countryName) {
    return allCities.where(((city) => city.getCountryId == country.getId)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    child: Text(
                      country.getName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                ),
              ),
            ),
            Expanded(
              child: CityListView(
                cityList: getCityList(country.getName),
                cardOnTap: (City selectedCity) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NextCityScreen(startCity: selectedCity),
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
            )
          ],
        ),
      ),
    );
  }
}