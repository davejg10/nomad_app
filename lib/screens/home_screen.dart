import 'package:flutter/material.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/screens/start_city_screen.dart';

import '../domain/country.dart';
import '../widgets/country_searchbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DestinationRepository repo = DestinationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CountrySearchBar(
            countryList: repo.getCountries(),
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