import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/backend_repository_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';

import '../../../providers/travel_preference_provider.dart';

final availableCityListProvider = AsyncNotifierProvider<AvailableCityListNotifier, Set<Neo4jCity>>(
      () => AvailableCityListNotifier(),
);

class AvailableCityListNotifier extends AsyncNotifier<Set<Neo4jCity>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('available_city_list_provider.dart'));

  @override
  FutureOr<Set<Neo4jCity>> build() {
    final originCitySelected = ref.watch(originCitySelectedProvider);
    final destinationCountrySelected = ref.watch(destinationCountrySelectedProvider);
    if (originCitySelected != null && destinationCountrySelected != null) {
      return _fetchAllNextCities(originCitySelected, destinationCountrySelected.getId);
    }
    return {};
  }

  Future<Set<Neo4jCity>> _fetchAllNextCities(Neo4jCity selectedCity, String targetCityCountryId) async {
    Map<CityCriteria, int> cityCriteriaPreferences = {};
    for(CityCriteria criteria in CityCriteria.values) {
      cityCriteriaPreferences[criteria] = ref.read(travelPreferenceProvider(criteria.name));
    }

    int costPreference = ref.read(travelPreferenceProvider('COST'));
    Set<Neo4jRoute> routes = await ref.read(backendRepositoryProvider).fetchRoutesByTargetCityCountryIdOrderByPreferences(selectedCity.getId, targetCityCountryId, cityCriteriaPreferences, costPreference);
    ref.read(lastCitySelectedProvider.notifier).setGeoEntity(selectedCity.withRoutes(routes));
    Set<Neo4jCity> targetCities = {};
    for (Neo4jRoute route in routes) {
      _logger.i("Adding ${route.getTargetCity} to Set of target Cities");
      targetCities.add(route.getTargetCity);
    }
    _logger.i("Final set of targetCities: $targetCities");
    return targetCities;
  }

  void fetchAllNextCities() async {
    Neo4jCity lastCitySelected = ref.read(lastCitySelectedProvider)!;
    String targetCityCountryId = ref.read(destinationCountrySelectedProvider)!.getId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAllNextCities(lastCitySelected, targetCityCountryId));
  }

  void reset() {
    ref.invalidateSelf();
  }

}