import 'package:nomad/domain/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_list_provider.g.dart';

@riverpod
class RouteList extends _$RouteList {

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