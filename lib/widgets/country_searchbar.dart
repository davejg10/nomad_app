import 'package:flutter/material.dart';
import 'package:nomad/screens/start_city_screen.dart';

import '../domain/country.dart';
import 'country_card.dart';

class CountrySearchBar extends StatefulWidget {
  CountrySearchBar({super.key, required this.allCountries});

  List<Country> allCountries;

  @override
  State<CountrySearchBar> createState() => _CountrySearchBarState();
}

class _CountrySearchBarState extends State<CountrySearchBar> {

  late final SearchController _searchController;
  late final FocusNode _focusNode;
  List<Country> filteredCountryList = [];

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    _focusNode = FocusNode();
    filteredCountryList = widget.allCountries;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _searchController.openView();
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
    return SearchAnchor(
      viewConstraints: BoxConstraints(maxHeight: 300),
      viewBuilder: (_) {
        // Constructing the List of search result Widgets here rather than suggestionBuilder as it allows us to use lazy initialization for the widgets.
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredCountryList.length,
            itemBuilder: (context, index) {
              return CountryCard(
                country: filteredCountryList[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StartCityScreen(country: filteredCountryList[index]),
                    ),
                  );
                },
              );
            },
          );
      },
      viewOnSubmitted: (userInput) {
        bool validCountryInput = widget.allCountries.where((country) => country.getName == userInput).isNotEmpty;

        if (validCountryInput) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StartCityScreen(countryName: userInput),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'That is not a valid country in our list...',
                style: TextStyle(fontSize: 20, fontFamily: "DMSans-Regular.ttf"),
              ),
            ),
          );
        }
      },
      isFullScreen: false,
      searchController: _searchController,
      viewOnChanged: (userInput) {
        if (userInput.trim().isEmpty) {
          filteredCountryList = List.from(widget.allCountries);
        } else {
          filteredCountryList = widget.allCountries.where((country) => country.getName.toLowerCase().contains(userInput.toLowerCase())).toList();
        }
      },
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          hintText: 'Search country here...',
          hintStyle: WidgetStateProperty.all(
              TextStyle(
                fontStyle: FontStyle.italic,
              ),
          ),
          autoFocus: true,
          focusNode: _focusNode,
          controller: searchController,
          trailing: const [Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.search),
          )],
          onTap: () {
            searchController.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController searchController) {
        return [Text('required but not used - this allows us to provide our own ListView.Builder above for lazy loading...')];
      }
    );
  }
}