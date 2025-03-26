import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/neo4j/neo4j_city.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/target_cities_given_country_provider.dart';

import '../domain/neo4j/neo4j_route.dart';
import '../screens/select_city/providers/providers.dart';

final itineraryListProvider = NotifierProvider<ItineraryNotifier, List<Neo4jCity>>(ItineraryNotifier.new);

class ItineraryNotifier extends Notifier<List<Neo4jCity>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('itinerary_list_provider.dart'));

  @override
  List<Neo4jCity> build() {
    return [];
  }

  void addToItinerary(Neo4jCity selectedCity) {
    Neo4jCity lastCitySelected = ref.read(lastCitySelectedProvider)!;
    Set<Neo4jRoute> routesToSelectedCity = lastCitySelected.getRoutes.where((route) => route.getTargetCity.getId == selectedCity.getId).toSet();
    ref.read(targetCitiesGivenCountryProvider.notifier).fetchTargetCities(selectedCity);
    if (state.isEmpty) {
      ref.read(originCitySelectedProvider.notifier).setGeoEntity(lastCitySelected.withRoutes(routesToSelectedCity));
      state = [selectedCity];
    } else {
      Neo4jCity lastAdded = state.removeLast().withRoutes(routesToSelectedCity);
      state = [...state, lastAdded, selectedCity];
    }
  }

  void removeLastFromItinerary() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);

      if (state.length > 1) {
        ref.read(targetCitiesGivenCountryProvider.notifier).fetchTargetCities(
            state.last);
      } else {
        ref.read(targetCitiesGivenCountryProvider.notifier).reset();
      }
    }
  }

  double calculateCityCriteriaTotal(CityCriteria criteria) {
    double criteriaScore = 0.0;
    for (Neo4jCity city in state) {
      criteriaScore += (city.getCityRatings[criteria]! / state.length);
    }
    return double.parse(criteriaScore.toStringAsFixed(2));
  }
}
