import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/sql/route_instance.dart';
import 'package:nomad/screens/route_view/providers/trip_date_providers.dart';

final routeListProvider = NotifierProvider<RouteListNotifier, Map<int, RouteInstance>>(RouteListNotifier.new);

class RouteListNotifier extends Notifier<Map<int, RouteInstance>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('itinerary_list_provider.dart'));

  @override
  Map<int, RouteInstance> build() {
    return {};
  }

  void addToRouteList(int selectedCardIndex, RouteInstance routeInstance) {
    _logger.e("inputting RouteInstace at index $selectedCardIndex");
    state = {
      ...state, // copy existing key-value pairs
      selectedCardIndex: routeInstance, // overwrite or add
    };
  }

  void removeFromRouteList(int selectedCardIndex) {
    state = Map.fromEntries(
      state.entries.where((entry) => entry.key != selectedCardIndex),
    );
  }

  RouteInstance? getRouteInstance(int selectedCardIndex) {
    if (state.containsKey(selectedCardIndex)) {
      return state[selectedCardIndex]!;
    }
    return null;
  }

  DateTime? getRouteDepartLowerBound(int selectedCardIndex) {
    _logger.w('RouteListState is: $state');
    Map<int, RouteInstance> earlierRouteInstances = Map.fromEntries(
      state.entries.where((entry) => entry.key < selectedCardIndex),
    );

    if (earlierRouteInstances.isNotEmpty) {
      List<int> mapKeysAsList = earlierRouteInstances.keys.toList();
      mapKeysAsList.sort((a, b) => a.compareTo(b));
      return earlierRouteInstances[mapKeysAsList.last]!.getArrival;
    }

    DateTime? tripStartDate = ref.read(tripDateStartProvider);

    return tripStartDate;
  }

  DateTime? getRouteDepartUpperBound(int selectedCardIndex) {
    Map<int, RouteInstance> laterRouteInstances = Map.fromEntries(
      state.entries.where((entry) => entry.key > selectedCardIndex),
    );

    if (laterRouteInstances.isNotEmpty) {
      List<int> mapKeysAsList = laterRouteInstances.keys.toList();
      mapKeysAsList.sort((a, b) => a.compareTo(b));
      return laterRouteInstances[mapKeysAsList.first]!.getDeparture;
    }

    DateTime? tripStartDate = ref.read(tripDateEndProvider);

    return tripStartDate;
  }

  // double calculateCityCriteriaTotal(CityCriteria criteria) {
  //   double criteriaScore = 0.0;
  //   for (Neo4jCity city in state) {
  //     criteriaScore += (city.getCityRatings[criteria]! / state.length);
  //   }
  //   return double.parse(criteriaScore.toStringAsFixed(2));
  // }
}
