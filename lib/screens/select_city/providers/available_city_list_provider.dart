import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city.dart';
import 'package:nomad/providers/route_list_provider.dart';

import 'all_cities_provider.dart';

final availableCityListProvider = Provider<List<City>>((ref) {
  List<City> routeList = ref.watch(routeListProvider);

  List<City> allCities = ref.watch(allCitiesProvider);
  if (routeList.isEmpty) {
    return allCities;
  }

  return allCities.where((city) => !routeList.contains(city)).toList();
});