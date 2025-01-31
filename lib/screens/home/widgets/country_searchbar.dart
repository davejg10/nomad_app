import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/selected_country_provider.dart';
import 'package:nomad/screens/home/providers/queried_country_list_provider.dart';
import 'package:nomad/providers/search_widget_visibility_provider.dart';
import 'package:nomad/screens/select_city/select_city_screen.dart';
import 'package:nomad/widgets/error_snackbar.dart';

import '../../../providers/logger_provider.dart';
import '../providers/all_countries_provider.dart';

class CountrySearchbar extends ConsumerStatefulWidget {
  const CountrySearchbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountrySearchbarState();
}

class _CountrySearchbarState extends ConsumerState<CountrySearchbar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SearchBar(
      onSubmitted: (userInput) {
        Country? submittedCountry = ref.read(queriedCountriesListProvider.notifier).submit(userInput);
        if (submittedCountry != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectCityScreen(),
            ),
          );
        } else {
          _focusNode.requestFocus();
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar('$userInput is not a valid country in our list...')
          );
        }
      },
      onTap: () {
        ref.read(searchWidgetVisibility(SearchVisibility.SEARCH_RESULTS).notifier).open();
      },
      onChanged: (userInput) {
        ref.read(queriedCountriesListProvider.notifier).filter(userInput);
      },
      controller: _searchController,
      focusNode: _focusNode,
      hintText: 'Where to next..?',
      leading: Icon(Icons.search),
      trailing: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _searchController.text = '';
            ref.read(searchWidgetVisibility(SearchVisibility.SEARCH_RESULTS).notifier).close();
            ref.read(queriedCountriesListProvider.notifier).reset();
          },
        ),
      ]
    );
  }
}
