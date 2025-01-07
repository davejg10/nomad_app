import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/screens/select_city/providers/city_searchbar_visibility_provider.dart';

import '../../../domain/city.dart';
import '../../../providers/route_list_provider.dart';
import '../providers/available_city_list_provider.dart';
import '../providers/queried_city_list_provider.dart';

class CitySearchbar extends ConsumerStatefulWidget {
  const CitySearchbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitySearchbarState();
}

class _CitySearchbarState extends ConsumerState<CitySearchbar> {

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

  void closeSearchBar() {
    _searchController.text = '';
    ref.read(citySearchbarVisibilityProvider.notifier).close();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onSubmitted: (userInput) {
        List<City> possibleValidCity = ref.read(availableCityListProvider).where((city) => city.getName.toLowerCase() == userInput.trim().toLowerCase()).toList();
        bool validCityInput = possibleValidCity.isNotEmpty;

        if (validCityInput) {
          ref.read(routeListProvider.notifier).addToItinerary(possibleValidCity.first);
          closeSearchBar();
        } else {
          // TODO add popup diaglogue
        }
      },
      onChanged: (userInput) {
        ref.read(queriedCityListProvider.notifier).filter(userInput);
      },
      controller: _searchController,
      hintText: 'Search cities...',
      leading: Icon(Icons.search),
      trailing: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            ref.read(queriedCityListProvider.notifier).reset();
            closeSearchBar();
          },
        ),
      ]
    );
  }
}
