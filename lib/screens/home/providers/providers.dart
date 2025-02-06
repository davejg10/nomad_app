import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/country.dart';
import 'package:nomad/providers/backend_repository_provider.dart';
import 'package:nomad/providers/generic_queried_list_providers.dart';

import 'all_origin_cities_provider.dart';

final allCountriesProvider = FutureProvider<Set<Country>>((ref) async {
  return ref.read(backendRepositoryProvider).getCountries();
});

// For the `ORIGIN_COUNTRY` dropdown
final originCountryQueriedListProvider = countryQueriedListTemplate(allCountriesProvider);

// For the `ORIGIN_CITY` dropdown
final originCityQueriedListProvider = cityQueriedListTemplate(allOriginCitiesProvider);

// For the `DESTINATION_COUNTRY` dropdown
final destinationCountryQueriedListProvider = countryQueriedListTemplate(allCountriesProvider);
