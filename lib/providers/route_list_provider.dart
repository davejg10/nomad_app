import 'package:logger/logger.dart';
import 'package:nomad/custom_log_printer.dart';
import 'package:nomad/domain/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad/domain/city_criteria.dart';
import 'package:nomad/domain/route_metric.dart';

import '../domain/route_entity.dart';

final routeListProvider = NotifierProvider<RouteList, List<RouteEntity>>(RouteList.new);

class RouteList extends Notifier<List<RouteEntity>> {
  static Logger _logger = Logger(printer: CustomLogPrinter('route_list_provider.dart'));

  @override
  List<RouteEntity> build() {
    return [];
  }

  void addToItinerary(RouteEntity selectedRoute) {
    state = [...state, selectedRoute];
  }

  void removeFromItinerary(RouteEntity selectedRoute) {
    state = state.where((route) => route != selectedRoute).toList();
  }

  void removeLastFromItinerary() {
    state = state.sublist(0, state.length - 1);
  }

  double calculateRouteMetricTotal(RouteMetric metric) {
    double total = 0;
    for (RouteEntity route in state) {
      total += metric == RouteMetric.TIME ? route.getTime : route.getPopularity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateCityCriteriaTotal(CityCriteria criteria) {
    List<City> allCities = state.map((route) => route.getTargetCity).toList();
    double criteriaScore = 0.0;
    for (City city in allCities) {
      criteriaScore += (city.getCityRatings[criteria]! / state.length);
    }
    return double.parse(criteriaScore.toStringAsFixed(2));
  }
}
