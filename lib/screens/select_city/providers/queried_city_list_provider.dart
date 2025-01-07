import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/city.dart';
import 'available_city_list_provider.dart';

part 'queried_city_list_provider.g.dart';

@riverpod
class QueriedCityList extends _$QueriedCityList {

  @override
  List<City> build() {
    return ref.watch(availableCityListProvider);
  }

  void filter(String userInput) {
    List<City> cityList = ref.watch(availableCityListProvider);
    String sanitizedUserInput = userInput.trim().toLowerCase();
    state = cityList.where((city) => city.getName.toLowerCase().contains(sanitizedUserInput)).toList();
  }

  void reset() {
    ref.invalidateSelf();
  }
}