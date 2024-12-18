import 'package:flutter/material.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/global_screen.dart';
import 'package:nomad/screens/select_city_screen.dart';

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
    return GlobalScreen(
      child: Center(
        child: CountrySearchBar(
          countryList: repo.getCountries(),
          cardOnTap: (Country selectedCountry) {
            scopedCities = repo.getCitiesGivenCountry(selectedCountry.getId);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectCityScreen(country: selectedCountry),
              ),
            );
          },
          searchFieldOnSubmitted: (Country selectedCountry) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectCityScreen(country: selectedCountry),
              ),
            );
          },
        ),
      ),
    );
  }
}