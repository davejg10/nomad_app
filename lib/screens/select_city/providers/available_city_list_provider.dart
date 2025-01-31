import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/logger_provider.dart';
import 'package:nomad/providers/route_list_provider.dart';
import 'package:nomad/screens/select_city/providers/next_cities_provider.dart';

import 'all_cities_provider.dart';

final availableCityListProvider = FutureProvider<Set<City>>((ref) {
  Logger logger = ref.read(loggerProvider("available_city_list_provider.dart"));

  ref.watch(availableCitiesTriggerProvider);

  if (ref.read(routeListProvider).isEmpty) {
    return ref.watch(allCitiesProvider.future);
  } else {
    return ref.watch(nextCitiesListProvider.future);
  }
});

final availableCitiesTriggerProvider = Provider((ref) {
  ref.listen<List<City>>(routeListProvider, (previous, next) {
    if (next.isNotEmpty) {
      ref.read(nextCitiesListProvider.notifier).fetchNextCities(next.last.getId);
    }
    ref.notifyListeners();
  });
});