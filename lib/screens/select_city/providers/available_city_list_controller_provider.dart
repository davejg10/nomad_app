import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/screens/select_city/providers/target_cities_given_country_provider.dart';

import '../../../custom_log_printer.dart';
import '../../../domain/neo4j/neo4j_city.dart';

Logger _logger = Logger(printer: CustomLogPrinter('available_city_list_controller_provider.dart'));

// This is going to be the controller for fetching next cities.
// Eventually there will be multiple notifiers to fetch next cities based on various criteria e.g time, metric etc
// This provider will be a wrapper around all of them containing the logic on when to call which to return the set of next cities
final availableCityListControllerProvider = FutureProvider<Set<Neo4jCity>>((ref) async {

  Set<Neo4jRoute> routes = await ref.watch(targetCitiesGivenCountryProvider.future);
  Set<Neo4jCity> targetCities = {};
  for (Neo4jRoute route in routes) {
    targetCities.add(route.getTargetCity);
  }

  return targetCities;
});

