import 'package:flutter/material.dart';

import '../domain/country.dart';
import 'country_card.dart';

class CountrySearchBar extends StatefulWidget {
  const CountrySearchBar({super.key, required this.countryList, required this.cardOnTap, required this.searchFieldOnSubmitted});

  final List<Country> countryList;
  final void Function(Country selectedCountry) cardOnTap;
  final void Function(Country selectedCountry) searchFieldOnSubmitted;

  @override
  State<CountrySearchBar> createState() => _CountrySearchBarState();
}

class _CountrySearchBarState extends State<CountrySearchBar> {

  late final SearchController _searchController;
  List<Country> filteredCountryList = [];

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    filteredCountryList = widget.countryList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.openView();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        key: const Key('country_search_field'),
      viewConstraints: BoxConstraints(maxHeight: 300),
      viewBuilder: (_) {
        // Constructing the List of search result Widgets here rather than suggestionBuilder as it allows us to use lazy initialization for the widgets.
        ListView myView = ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredCountryList.length,
          itemBuilder: (context, index) {
            Country country = filteredCountryList[index];
            return CountryCard(
              key: Key('countryCard${country.getName}'),
              country: country,
              cardOnTap: widget.cardOnTap,
            );
          },
        );
        return myView;
      },
      viewOnSubmitted: (userInput) {
        List<Country> possibleValidCountry = widget.countryList.where((country) => country.getName.toLowerCase() == userInput.trim().toLowerCase()).toList();
        bool validCountryInput = possibleValidCountry.isNotEmpty;

        if (validCountryInput) {
          widget.searchFieldOnSubmitted(possibleValidCountry.first);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
          filteredCountryList = List.from(widget.countryList);
        } else {
          filteredCountryList = widget.countryList.where((country) => country.getName.toLowerCase().contains(userInput.toLowerCase())).toList();
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
          controller: searchController,
          trailing: const [Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.search),
          )],
          onTap: () {
            if (!searchController.isOpen) {
              searchController.openView();
            }
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController searchController) {
        return [Text('required but not used - this allows us to provide our own ListView.Builder above for lazy loading...')];
      }
    );
  }
}