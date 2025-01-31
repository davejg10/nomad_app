import 'package:nomad/domain/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/selected_country_provider.dart';
import 'all_countries_provider.dart';

// Provider definition
final queriedCountriesListProvider = AsyncNotifierProvider<QueriedCountriesList, Set<Country>>(
      () => QueriedCountriesList(),
);

class QueriedCountriesList extends AsyncNotifier<Set<Country>> {

  @override
  Future<Set<Country>> build() {
    return ref.watch(allCountriesProvider.future); //AsyncValue so need to watch for changes
  }

  void filter(String userInput) {
    final allCountriesProviderState = ref.read(allCountriesProvider);

    if (allCountriesProviderState.hasValue) {
      final sanitizedUserInput = userInput.trim().toLowerCase();
      final filteredList = allCountriesProviderState.value!
          .where((country) => country.getName.toLowerCase().contains(sanitizedUserInput))
          .toSet();

      state = AsyncValue.data(filteredList);
    }
  }

  Country? submit(String userInput)  {
    final sanitizedUserInput = userInput.trim().toLowerCase();

    if (state.hasValue) {
      Set<Country> possibleValidCountry = state.value!.where((country) =>
      country.getName.toLowerCase() == sanitizedUserInput)
          .toSet();
      if (possibleValidCountry.isNotEmpty) {
        ref.read(selectedCountryProvider.notifier).setCountry(possibleValidCountry.first);
        return possibleValidCountry.first;
      } else {
        return null;
      }
    }
  }

  void reset() {
    state = ref.read(allCountriesProvider);
  }
}