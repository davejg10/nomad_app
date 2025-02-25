import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/available_city_list_provider.dart';

// This is going to be the controller for fetching next cities.
// Eventually there will be multiple notifiers to fetch next cities based on various criteria e.g time, metric etc
// This provider will be a wrapper around all of them containing the logic on when to call which to return the set of next cities
final availableCityListControllerProvider = FutureProvider<Set<City>>((ref) {
  // Register listener
  ref.watch(_routeChangedTriggerProvider);

  return ref.watch(availableCityListProvider.future);
});


final _routeChangedTriggerProvider = Provider((ref) {

  ref.listen<List<RouteEntity>>(routeListProvider, (previous, next) {
    if (next.isNotEmpty) {
      String destinationCountryId = ref.read(destinationCountrySelectedProvider)!.getId;
      ref.read(availableCityListProvider.notifier).fetchAllNextCities(next.last.getTargetCity.getId, destinationCountryId);
    } else if (next.isEmpty) {
      ref.read(availableCityListProvider.notifier).reset();
    }
  });
});