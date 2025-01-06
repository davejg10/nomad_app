import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';
import 'package:nomad/data/destination_respository.dart';
import 'package:nomad/screen_scaffold.dart';
import 'package:nomad/screens/home/widgets/country_list_view.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';

import '../../domain/country.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DestinationRepository repo = DestinationRepository();
  List<Country> countryList = [];
  List<Country> filteredCountryList = [];
  final TextEditingController _searchController = TextEditingController();
  bool searchResultsOpen = false;

  @override
  void initState() {
    super.initState();
    countryList = repo.getCountries();
    filteredCountryList = countryList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void closeSearchResults() {
    setState(() {
      _searchController.text = '';
      searchResultsOpen = false;
      filteredCountryList = countryList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: kSearchBarPadding,
              //TODO Refactor into own widget once state management tool is used.
              child: SearchBar(
                onSubmitted: (userInput) {
                  List<Country> possibleValidCountry = countryList.where((
                      country) =>
                  country.getName.toLowerCase() == userInput.trim().toLowerCase())
                      .toList();
                  bool validCountryInput = possibleValidCountry.isNotEmpty;
                  if (validCountryInput) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectCityScreen(country: possibleValidCountry.first),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'That is not a valid country in our list...',
                          style: TextStyle(
                              fontSize: 20, fontFamily: "DMSans-Regular.ttf"),
                        ),
                      ),
                    );
                  }
                },
                onTap: () {
                  setState(() {
                    searchResultsOpen = true;
                  });
                },
                onChanged: (userInput) {
                  setState(() {
                    if (userInput.trim().isEmpty) {
                      filteredCountryList = List.from(countryList);
                    } else {
                      filteredCountryList = countryList.where((country) => country.getName.toLowerCase().contains(userInput.toLowerCase())).toList();
                    }
                  });
                },
                controller: _searchController,
                hintText: 'Where to next..?',
                leading: Icon(Icons.search),
                trailing: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        closeSearchResults();
                      });
                    },
                  ),
                ]
              ),
            ),
            if (searchResultsOpen)
              Flexible(
                child: CountryListView(
                  countryList: filteredCountryList,
                  cardOnTap: (Country selectedCountry) {
                    scopedCities = repo.getCitiesGivenCountry(selectedCountry.getId);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectCityScreen(country: selectedCountry),
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