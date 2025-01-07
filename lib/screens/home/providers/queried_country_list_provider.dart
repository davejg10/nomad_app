import 'package:nomad/domain/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'all_countries_provider.dart';

part 'queried_country_list_provider.g.dart';

@riverpod
class QueriedCountryList extends _$QueriedCountryList {

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