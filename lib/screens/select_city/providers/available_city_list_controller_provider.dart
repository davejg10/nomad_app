import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/neo4j/neo4j_route.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';

import '../../../domain/neo4j/neo4j_city.dart';

// This is going to be the controller for fetching next cities.
// Eventually there will be multiple notifiers to fetch next cities based on various criteria e.g time, metric etc
// This provider will be a wrapper around all of them containing the logic on when to call which to return the set of next cities
final availableCityListControllerProvider = FutureProvider<Set<Neo4jCity>>((ref) {
  // Register listener
  ref.watch(_routeChangedTriggerProvider);

  return ref.watch(availableCityListProvider.future);
});


final _routeChangedTriggerProvider = Provider((ref) {

  ref.listen<List<Neo4jRoute>>(routeListProvider, (previousState, nextState) {
    if (nextState.isNotEmpty) {
      ref.read(availableCityListProvider.notifier).fetchAllNextCities();
    } else if (nextState.isEmpty) {
      ref.read(availableCityListProvider.notifier).reset();
    }
  });
});