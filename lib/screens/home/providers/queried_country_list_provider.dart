import 'package:nomad/domain/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_countries_provider.dart';

final queriedCountryListProvider = NotifierProvider<QueriedCountryList, List<Country>>(QueriedCountryList.new);

class QueriedCountryList extends Notifier<List<Country>> {

  @override
  List<Country> build() {
    return ref.read(allCountriesProvider);
  }

  void filter(String userInput) {
    List<Country> countryList = ref.read(allCountriesProvider);
    String sanitizedUserInput = userInput.trim().toLowerCase();
    state = countryList.where((country) => country.getName.toLowerCase().contains(sanitizedUserInput)).toList();
  }

  void reset() {
    ref.invalidateSelf();
  }
}