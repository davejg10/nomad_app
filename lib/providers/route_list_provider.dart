import 'package:nomad/domain/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeListProvider = NotifierProvider<RouteList, List<City>>(RouteList.new);

class RouteList extends Notifier<List<City>> {
  @override
  List<City> build() {
    return [];
  }

  void addToItinerary(City selectedCity) {
    state = [...state, selectedCity];
  }

  void removeFromItinerary(City selectedCity) {
    state = state.where((city) => city.getName != selectedCity.getName).toList();
  }

  void removeLastFromItinerary() {
    state = state.sublist(0, state.length - 1);
  }
}
