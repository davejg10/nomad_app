import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/backend_repository_provider.dart';
import 'package:nomad/providers/itinerary_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';

import '../../../providers/travel_preference_provider.dart';

final targetCitiesGivenCountryProvider = AsyncNotifierProvider<TargetCitiesGivenCountryListNotifier, Set<Neo4jRoute>>(
      () => TargetCitiesGivenCountryListNotifier(),
);

class TargetCitiesGivenCountryListNotifier extends AsyncNotifier<Set<Neo4jRoute>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('target_cities_given_country_provider.dart'));

  @override
  FutureOr<Set<Neo4jRoute>> build() {
    final originCitySelected = ref.read(originCitySelectedProvider); //important this is read as we alter with routes later
    final destinationCountrySelected = ref.watch(destinationCountrySelectedProvider);
    if (originCitySelected != null && destinationCountrySelected != null) {
      return _fetchTargetCities(originCitySelected, destinationCountrySelected.getId);
    }
    return {};
  }

  Future<Set<Neo4jRoute>> _fetchTargetCities(Neo4jCity selectedCity, String targetCityCountryId) async {
    Map<CityCriteria, int> cityCriteriaPreferences = {};
    for(CityCriteria criteria in CityCriteria.values) {
      cityCriteriaPreferences[criteria] = ref.read(travelPreferenceProvider(criteria.name));
    }
    int costPreference = ref.read(travelPreferenceProvider('COST'));

    Set<Neo4jRoute> routes = await ref.read(backendRepositoryProvider).fetchRoutesByTargetCityCountryIdOrderByPreferences(selectedCity.getId, targetCityCountryId, cityCriteriaPreferences, costPreference);

    Neo4jCity selectedCityWithRoutes = selectedCity.withRoutes(routes);
    ref.read(lastCitySelectedProvider.notifier).setGeoEntity(selectedCityWithRoutes);

    return routes;
  }

  void fetchTargetCities(Neo4jCity selectedCity) async {
    String targetCityCountryId = ref.read(destinationCountrySelectedProvider)!.getId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTargetCities(selectedCity, targetCityCountryId));
  }

  void reset() {
    ref.invalidateSelf();
  }

}