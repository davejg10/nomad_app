import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/city.dart';
import '../../../providers/route_list_provider.dart';
import 'available_city_list_provider.dart';

final queriedCityListProvider = AsyncNotifierProvider<QueriedCityList, Set<City>>(
      () => QueriedCityList(),
);

class QueriedCityList extends AsyncNotifier<Set<City>> {

  @override
  Future<Set<City>> build() {
    return ref.watch(availableCityListProvider.future); // Re-initialized whenever availableCityList state changes
  }

  void filter(String userInput) {
    final availableCityListProviderState = ref.read(availableCityListProvider);

    if (availableCityListProviderState.hasValue) {
      final sanitizedUserInput = userInput.trim().toLowerCase();
      final filteredList = availableCityListProviderState.value!
          .where((city) => city.getName.toLowerCase().contains(sanitizedUserInput))
          .toSet();

      state = AsyncValue.data(filteredList);
    }
  }

  City? submit(String userInput)  {
    final sanitizedUserInput = userInput.trim().toLowerCase();

    if (state.hasValue) {
      Set<City> possibleValidCity = state.value!.where((city) =>
      city.getName.toLowerCase() == sanitizedUserInput)
          .toSet();
      if (possibleValidCity.isNotEmpty) {
        ref.read(routeListProvider.notifier).addToItinerary(possibleValidCity.first);
        return possibleValidCity.first;
      } else {
        return null;
      }
    }
  }

  void reset() {
    state = ref.read(availableCityListProvider);
  }
}