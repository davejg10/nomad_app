import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/domain/route_entity.dart';
import 'package:nomad/providers/backend_repository_provider.dart';
import 'package:nomad/providers/selected_geo_entity_provider.dart';
import 'package:nomad/screens/select_city/providers/providers.dart';

final availableCityListProvider = AsyncNotifierProvider<AvailableCityListNotifier, Set<City>>(
      () => AvailableCityListNotifier(),
);

class AvailableCityListNotifier extends AsyncNotifier<Set<City>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('available_city_list_provider.dart'));

  @override
  FutureOr<Set<City>> build() {
    final originCitySelected = ref.watch(originCitySelectedProvider);
    final destinationCountrySelected = ref.watch(destinationCountrySelectedProvider);
    if (originCitySelected != null && destinationCountrySelected != null) {
      return _fetchAllNextCities(originCitySelected.getId, destinationCountrySelected.getId);
    }
    return {};
  }

  Future<Set<City>> _fetchAllNextCities(String cityId, String countryId) async {
    City fetchedCity = await ref.read(backendRepositoryProvider).findByIdFetchRoutesByCountryId(cityId, countryId);
    ref.read(currentCitySelectedProvider.notifier).setGeoEntity(fetchedCity);
    Set<City> targetCities = {};
    for (RouteEntity route in fetchedCity.getRoutes) {
      targetCities.add(route.getTargetCity);
    }
    return targetCities;
  }

  void fetchAllNextCities(String cityId, String countryId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAllNextCities(cityId, countryId));
  }

  void reset() {
    ref.invalidateSelf();
  }

}