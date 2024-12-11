import 'package:flutter/material.dart';
import 'package:nomad/screens/start_city_screen.dart';

import '../constants.dart';
import '../domain/country.dart';
import '../widgets/country_searchbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CountrySearchBar(
            countryList: allCountries,
            cardOnTap: (Country selectedCountry) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StartCityScreen(country: selectedCountry),
                ),
              );
            },
            searchFieldOnSubmitted: (Country selectedCountry) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StartCityScreen(country: selectedCountry),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}