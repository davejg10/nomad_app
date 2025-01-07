import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/selected_country_provider.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';
import 'package:nomad/screens/home/providers/country_search_results_visibility_provider.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';

import '../providers/all_countries_provider.dart';

class CountrySearchbar extends ConsumerStatefulWidget {
  const CountrySearchbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountrySearchbarState();
}

class _CountrySearchbarState extends ConsumerState<CountrySearchbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
        onSubmitted: (userInput) {
          List<Country> possibleValidCountry = ref.read(allCountriesProvider).where((
              country) =>
          country.getName.toLowerCase() == userInput.trim().toLowerCase())
              .toList();
          bool validCountryInput = possibleValidCountry.isNotEmpty;
          if (validCountryInput) {
            ref.read(selectedCountryProvider.notifier).setCountry(possibleValidCountry.first);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectCityScreen(),
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
          ref.read(countrySearchResultsVisibilityProvider.notifier).open();
        },
        onChanged: (userInput) {
          ref.read(queriedCountryListProvider.notifier).filter(userInput);
        },
        controller: _searchController,
        hintText: 'Where to next..?',
        leading: Icon(Icons.search),
        trailing: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _searchController.text = '';
              ref.read(countrySearchResultsVisibilityProvider.notifier).close();
              ref.read(queriedCountryListProvider.notifier).reset();
            },
          ),
        ]
    );
  }
}
