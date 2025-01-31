import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/destination_repository_provider.dart';

final nextCitiesListProvider = AsyncNotifierProvider<NextCitiesList, Set<City>>(
      () => NextCitiesList(),
);

class NextCitiesList extends AsyncNotifier<Set<City>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('next_cities_provider.dart'));

  @override
  FutureOr<Set<City>> build() {
    return {};
  }

  void fetchNextCities(String cityId) async {
    state = await AsyncValue.guard(() async {
      City fetchedCity = await ref.read(destinationRepositoryProvider).findByIdFetchRoutes(cityId);
      Set<City> targetCities = fetchedCity.getRoutes.map((route) {
        _logger.w("In fetchNextCities; with route and targetCity: ${route.getTargetCity}");
        return route.getTargetCity;
      }).toSet();
      _logger.w("List of targetCities returned: $targetCities");
      return targetCities;
    });
  }

}