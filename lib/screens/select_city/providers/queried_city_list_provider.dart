import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/city.dart';
import 'available_city_list_provider.dart';

final queriedCityListProvider = NotifierProvider<QueriedCityList, List<City>>(QueriedCityList.new);

class QueriedCityList extends Notifier<List<City>> {

  @override
  List<City> build() {
    return ref.watch(availableCityListProvider); // Re-initiazlied whenever availableCityList state changes
  }

  void filter(String userInput) {
    List<City> availableCities = ref.read(availableCityListProvider);
    String sanitizedUserInput = userInput.trim().toLowerCase();
    state = availableCities.where((city) => city.getName.toLowerCase().contains(sanitizedUserInput)).toList();
  }

  void reset() {
    ref.invalidateSelf();
  }
}