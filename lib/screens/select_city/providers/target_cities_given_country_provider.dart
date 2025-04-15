import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_country.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/repository_providers.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/screens/home/providers/selected_countries_provider.dart';

import '../../../providers/travel_preference_provider.dart';

final targetCitiesGivenCountryProvider = AsyncNotifierProvider<TargetCitiesGivenCountryListNotifier, Set<Neo4jRoute>>(
      () => TargetCitiesGivenCountryListNotifier(),
);

class TargetCitiesGivenCountryListNotifier extends AsyncNotifier<Set<Neo4jRoute>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('target_cities_given_country_provider.dart'));

  @override
  FutureOr<Set<Neo4jRoute>> build() {
    return {};
  }

  Future<Set<Neo4jRoute>> _fetchTargetCities(Neo4jCity selectedCity) async {
    Set<Neo4jCountry> selectedCountries = ref.read(selectedCountryListProvider);
    Map<CityCriteria, int> cityCriteriaPreferences = {};
    for(CityCriteria criteria in CityCriteria.values) {
      cityCriteriaPreferences[criteria] = ref.read(travelPreferenceProvider(criteria.name));
    }
    int costPreference = ref.read(travelPreferenceProvider('COST'));

    Set<Neo4jRoute> routes = await ref.read(cityRepositoryProvider).fetchRoutesByTargetCityCountryIdsOrderByPreferences(selectedCity.getId, selectedCountries, cityCriteriaPreferences, costPreference);

    ref.read(itineraryListProvider.notifier).addFetchedRoutes(routes);

    return routes;
  }

  void fetchTargetCities(Neo4jCity selectedCity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTargetCities(selectedCity));
  }

  void reset() {
    ref.invalidateSelf();
  }

}